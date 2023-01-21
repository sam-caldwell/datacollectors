package main

/*
	inputs:
		from kafka "scraper_task"
			{
				url: <string>,
				target: <string>
			}
		from env vars
			"KAFKA_HOST": <string>,
			"KAFKA_PORT": <int>

	output:
		To kafka (see input target):
			{
				url: <string>,
				html: <string>,
				collectedAt: <timestamp>
			}

	processor:
		- Given a URL, scrape the page.
		- Publish the HTML content to the topic
*/
