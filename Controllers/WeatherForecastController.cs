// Copyright The OpenTelemetry Authors
// SPDX-License-Identifier: Apache-2.0

namespace Examples.AspNetCore.Controllers;

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Net.Http;
using System.Security.Cryptography;
using Examples.AspNetCore;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;

[ApiController]
[Route("[controller]")]
public class WeatherForecastController : ControllerBase
{
    private static readonly string[] Summaries =
    [
        "Freezing", "Bracing", "Chilly", "Cool", "Mild", "Warm", "Balmy", "Hot", "Sweltering", "Scorching"
    ];

    private static readonly HttpClient HttpClient = new();

    private readonly ILogger<WeatherForecastController> logger;
    private static readonly ActivitySource activitySource = new("Example.WeatherForecast");

    public WeatherForecastController(ILogger<WeatherForecastController> logger)
    {
        this.logger = logger ?? throw new ArgumentNullException(nameof(logger));
    }

    [HttpGet]
    public IEnumerable<WeatherForecast> Get()
    {
        using var scope = this.logger.BeginIdScope(Guid.NewGuid().ToString("N"));

        // Making a http call here to serve as an example of
        // how dependency calls will be captured and treated
        // automatically as child of incoming request.
        var res = HttpClient.GetStringAsync(new Uri("http://google.com")).Result;

        // Optional: Manually create an activity. This will become a child of
        // the activity created from the instrumentation library for AspNetCore.
        // Manually created activities are useful when there is a desire to track
        // a specific subset of the request. In this example one could imagine
        // that calculating the forecast is an expensive operation and therefore
        // something to be distinguished from the overall request.
        // Note: Tags can be added to the current activity without the need for
        // a manual activity using Activity.Current?.SetTag()
        using var activity = activitySource.StartActivity("calculate forecast");

        var forecast = Enumerable.Range(1, 5).Select(index => new WeatherForecast
        {
            Date = DateTime.Now.AddDays(index),
            TemperatureC = RandomNumberGenerator.GetInt32(-20, 55),
            Summary = Summaries[RandomNumberGenerator.GetInt32(Summaries.Length)],
        })
        .ToArray();

        logger.WeatherForecastGenerated(LogLevel.Information, forecast.Length, forecast);

        return forecast;
    }
}
