using System.CommandLine;
using System.CommandLine.Builder;
using System.CommandLine.Hosting;
using System.CommandLine.NamingConventionBinder;
using System.CommandLine.Parsing;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using QueueTool;

const string RABBITMQ_EXCHANGE_NAME = "";
const string RABBITMQ_ROUTING_KEY = "demand-shaping";

var rootCommand = new RootCommand("Tool for testing the demand shaping message queue")
{
    new ConsumeCommand(),
    CommandOptions.ConnectionString,
};

return await new CommandLineBuilder(rootCommand)
    .UseDefaults()
    .UseHost(
        args => new HostBuilder().ConfigureDefaults(args),
        hostBuilder => hostBuilder
            .ConfigureServices(services => { })
            .UseCommandHandler<ConsumeCommand, ConsumeCommandHandler>()
            .ConfigureLogging(loggingBuilder => loggingBuilder
                .AddFilter("Microsoft", LogLevel.Warning)
                .AddFilter("QueueTool", LogLevel.Debug)
                .AddConsole()))
    .Build()
    .InvokeAsync(args);