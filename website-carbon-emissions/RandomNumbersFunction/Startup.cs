using Microsoft.AspNetCore.Http;
using Microsoft.Azure.Functions.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection;
using RandomNumbersFunction;

[assembly: FunctionsStartup(typeof(Startup))]

namespace RandomNumbersFunction;

public class Startup : FunctionsStartup
{
    public override void Configure(IFunctionsHostBuilder builder)
    {
        builder.Services.AddScoped<HttpContextAccessor>();
    }
}