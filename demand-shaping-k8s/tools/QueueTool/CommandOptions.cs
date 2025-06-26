using System.CommandLine;

namespace QueueTool;

internal static class CommandOptions
{
    public static Option<Uri> ConnectionString { get; } = new(
        ["-c", "--connection-string"],
        "The connection string for RabbitMQ");
    
    
    public static Option<TimeSpan> WaitTimer { get; } = new(
        ["-w", "--wait-timer"],
        () => TimeSpan.FromSeconds(10),
        "How long to wait until the next item is dequeued");

    public static Option<int> MessageCount { get; } = new(
        ["-m", "--message-count"],
        "How many message to add to the queue");
}