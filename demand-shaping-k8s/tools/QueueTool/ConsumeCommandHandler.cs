using System.CommandLine.Invocation;
using System.Text;
using Microsoft.Extensions.Logging;
using RabbitMQ.Client;

namespace QueueTool;

internal class ConsumeCommandHandler(ILogger<ConsumeCommand> logger) : ICommandHandler
{
    public int Invoke(InvocationContext context)
    {
        return InvokeAsync(context).GetAwaiter().GetResult();
    }

    public async Task<int> InvokeAsync(InvocationContext context)
    {
        var connectionString = context.ParseResult.GetValueForOption(CommandOptions.ConnectionString) ?? throw new InvalidOperationException();
        var waitTimer = context.ParseResult.GetValueForOption(CommandOptions.WaitTimer);
        var cancellationToken = CancellationToken.None;
        
        var connectionFactory = new ConnectionFactory
        {
            Uri = connectionString
        };
        await using var connection = await connectionFactory.CreateConnectionAsync(cancellationToken);
        await using var channel = await connection.CreateChannelAsync(cancellationToken: cancellationToken);
        await channel.QueueDeclareAsync(Constants.RABBITMQ_QUEUE_NAME, exclusive: false, durable: true, autoDelete: false,
            cancellationToken: cancellationToken);

        while (!cancellationToken.IsCancellationRequested)
        {
            var message = await channel.BasicGetAsync(Constants.RABBITMQ_QUEUE_NAME, true, cancellationToken);

            if (message is not null)
            {
                var bodyText = Encoding.UTF8.GetString(message.Body.ToArray());
                logger.LogInformation("Message dequeued: {body}", bodyText);
            }
            else
            {
                logger.LogDebug("No message to dequeue");
            }

            await Task.Delay(waitTimer, cancellationToken);
        }
        
        return 0;
    }
}