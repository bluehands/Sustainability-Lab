using System.CommandLine.Invocation;
using System.Text;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using RabbitMQ.Client;

namespace QueueTool;

internal class ProduceCommandHandler(ILogger<ProduceCommand> logger, IHostApplicationLifetime hostApplicationLifetime) : ICommandHandler
{
    public int Invoke(InvocationContext context) => InvokeAsync(context).GetAwaiter().GetResult();

    public async Task<int> InvokeAsync(InvocationContext context)
    {
        var connectionString = context.ParseResult.GetValueForOption(CommandOptions.ConnectionString) ?? throw new InvalidOperationException();
        var messageCount = context.ParseResult.GetValueForOption(CommandOptions.MessageCount);
        var cancellationToken = hostApplicationLifetime.ApplicationStopping;
        
        var connectionFactory = new ConnectionFactory
        {
            Uri = connectionString
        };
        await using var connection = await connectionFactory.CreateConnectionAsync(cancellationToken);
        await using var channel = await connection.CreateChannelAsync(cancellationToken: cancellationToken);
        await channel.QueueDeclareAsync(Constants.RABBITMQ_QUEUE_NAME, exclusive: false, durable: true, autoDelete: false,
            cancellationToken: cancellationToken);

        logger.LogInformation("Publishing {messageCount} message(s)...", messageCount);
        var now = DateTimeOffset.Now;
        for (var i = 0; i < messageCount; i++)
        {
            var bodyText = $"Demand shaping is awesome! (#{i:0000}; {now:G})";
            var body = Encoding.UTF8.GetBytes(bodyText);
            var properties = new BasicProperties()
            {
                ContentType = "text/plain",
                DeliveryMode = DeliveryModes.Persistent,
            };
            
            logger.LogDebug("Publishing message: {body}", bodyText);
            await channel.BasicPublishAsync(
                string.Empty,
                Constants.RABBITMQ_QUEUE_NAME,
                true,
                properties,
                body,
                cancellationToken);
        }
        
        return 0;
    }
}