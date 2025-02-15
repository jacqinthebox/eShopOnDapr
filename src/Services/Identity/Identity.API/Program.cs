﻿var appName = "Identity API";
var builder = WebApplication.CreateBuilder();

builder.AddCustomConfiguration();
builder.AddCustomSerilog();
builder.AddCustomMvc();
builder.AddCustomDatabase();
builder.AddCustomIdentity();
builder.AddCustomIdentityServer();
builder.AddCustomAuthentication();
builder.AddCustomHealthChecks();
builder.AddCustomApplicationServices();

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}

var pathBase = builder.Configuration["PATH_BASE"];
if (!string.IsNullOrEmpty(pathBase))
{
    app.UsePathBase(pathBase);
}

app.UseStaticFiles();

// This cookie policy fixes login issues with Chrome 80+ using HHTP
app.UseCookiePolicy(new CookiePolicyOptions { MinimumSameSitePolicy = SameSiteMode.Lax });

app.UseRouting();

app.Use((context, next) =>
{
    // If the Application Request Routing (ARR) SSL header is set,
    // set the request type to HTTPS. This ensures that Identity Server
    // uses HTTPS URLs in the configuration exposed by the Discovery Endpoint.
    // Ideally, we'd use the Forwarded Headers middleware for this,
    // but Azure Containers Apps currently sends `http` in the
    // x-forwarded-proto header instead of `https` (even when connecting
    // using https).
    // See https://github.com/microsoft/azure-container-apps/issues/97
    var xproto = context.Request.Headers["X-Forwarded-Proto"].ToString();
    if (context.Request.Headers.TryGetValue("x-arr-ssl", out var ssl) &&
        string.CompareOrdinal(ssl, "true") == 0 ||
        xproto !=null && xproto.StartsWith("https", StringComparison.OrdinalIgnoreCase))
    {
        context.Request.Scheme = "https";
    }

    return next();
});

app.UseIdentityServer();


app.UseAuthorization();

app.MapDefaultControllerRoute();

app.MapHealthChecks("/hc", new HealthCheckOptions()
{
    Predicate = _ => true,
    ResponseWriter = UIResponseWriter.WriteHealthCheckUIResponse
});
app.MapHealthChecks("/liveness", new HealthCheckOptions
{
    Predicate = r => r.Name.Contains("self")
});

try
{
    app.Logger.LogInformation("Seeding database ({ApplicationName})...", appName);

    // Apply database migration automatically. Note that this approach is not
    // recommended for production scenarios. Consider generating SQL scripts from
    // migrations instead.
    using (var scope = app.Services.CreateScope())
    {
        await SeedData.EnsureSeedData(scope, app.Configuration, app.Logger);
    }

    app.Logger.LogInformation("Starting web host ({ApplicationName})...", appName);
    app.Run();

    return 0;
}
catch (Exception ex)
{
    app.Logger.LogCritical(ex, "Host terminated unexpectedly ({ApplicationName})...", appName);
    return 1;
}
finally
{
    Serilog.Log.CloseAndFlush();
}
