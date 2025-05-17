using System.Text.Json;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Extensions.Logging;

namespace RandomNumbersFunction
{
    public class RandomNumberGeneratorFunction
    {
        private readonly ILogger<RandomNumberGeneratorFunction> _logger;
        private readonly HttpContext m_HttpContext;

        public RandomNumberGeneratorFunction(ILogger<RandomNumberGeneratorFunction> logger, HttpContextAccessor contextAccessor)
        {
            _logger = logger;
            m_HttpContext = contextAccessor.HttpContext;
        }

        [Function("RandomNumbers")]
        [Route("RandomNumbers/{length}")]
        public void GetRandom([HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", "options")] HttpRequest req, int length = 100)
        {
            var list =new List<RandomNumber>();
            for (int i = 0; i < length; i++)
            {
                list.Add(new RandomNumber(Random.Shared.Next()));
            }

            var response = m_HttpContext.Response;
            response.Body.Write(JsonSerializer.SerializeToUtf8Bytes(list));
            response.Headers.Add("Content-Type", "application/json; charset=utf-8");
            response.Headers.Add("Access-Control-Allow-Origin", "*");
            response.Headers.Add("Access-Control-Allow-Methods", "GET, POST, PUT, OPTIONS");
            response.Headers.Add("Access-Control-Allow-Headers", "*");
            response.Headers.Add("Access-Control-Allow-Credentials", "true");
            response.Headers.Add("Timing-Allow-Origin", "*");

        }
    }

    public record RandomNumber(int Number);
}



