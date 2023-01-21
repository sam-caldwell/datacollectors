DataCollector Command
=====================

## Objective:
Create a unified commandline tool for interacting with the `datacollectors` system.

## Command Usage:

* `datacollectors help`
  * print a command usage
  
* `datacollectors help <subcommand>`
  * print usage information for the given subcommand.
  
* `datacollector stats`
  * print the statistics for the data collector as a JSON object.
  * this should run the `datacollector <subcommand> stats` for relevant data.

* `datacollectors job list [-limit <integer>] [-offset <integer>]`
  * print list of current jobs and their status, execution frequency, last execution time and outcome.

* `datacollectors job create -name "jobname" -freq 50`
  * creates record in `jobSchedule` table with name and frequency (`freq` >=0)
      * `freq` is the minimum number of seconds between job runs.
  * returns integer `jobId` for the corresponding job.
  * throws exception on error.

* `datacollectors job update -name "jobname" -freq 60`
  * updates the `freq` interval for a given job.
  * throws exception if no such job exists.

* `datacollectors job disable -name "jobname"`
  * disables a job by setting status to `disabled`

* `datacollectors job enable -name "jobname"`
  * enables a job by setting its status to `not_started`

* `datacollectors job task add -job "jobname" -runner {{task runner name}} -arguments {{json args}}`
  * lookup the `runnerId` of an existing runner.  Throws exception if not found.
  * gets the `argumentSchema` of the named runner and validates arguments against the same.
    Throws exception if schema not satisfied.
  * creates the `JobTasks` record for the task with the above information and returns the new `taskId`

* `datacollectors job task list -job "jobname"`
  * list the `taskId`, `runnerId` and `arguments` for a given job.

* `datacollectors job task delete -job "jobname" -taskId {{integer}}`
  * Delete the identified task for a given job.
  * Fails silently if no such job-task combination exists.

* `datacollectors job runner create -name "runnerName" -args {{json schema}} \
                                    -image '{{container_image}}' [-description {{text}}]`
  * Create a new job runner.  This identifies the container to be run, the kafka topic where arguments will be queued
    as well as kafka topics for optional inputs and outputs from the runner.
  * The container image will be uploaded to the datacollectors docker registry.

* `datacollectors job runner delete -name "runnerName"`
  * Delete the identified runnerName or throw exception if the runner is still identified in any tasks.

* `datacollectors job runner list`
  * List the job runners in the system as a JSON object.

* `datacollectors job execute -job "jobname"`
  * Launch a job manually (useful for iterative development).

* `datacollectors job kill -job "jobname"`
  * Kill a job and its queued tasks.