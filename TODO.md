# Freshly-events TODO list

 - [x] Figure out how to pass context to data publisher. **Context is passed explicitly**
 - [x] Switch from synchronous to asynchronous message publishing. **A config option for this is available**
 - [x] Figure out how to unwind from using a specific framework (e.g Rails), but rather implement events in a general way suitable for plain ruby classes. **Event emitters inject in dynamic way based on what framework the gem is being used in.**
 - [x] Infer data in extensible way. Given a common context implement context handlers capable of fetching data for specific cases (Controller, ActiveJobs, Models, etc.). **Context handlers are introduced. New handlers might be implemented and registered easily**
 - [x] Figure out the most common default context handlers (Controller, something else). **Controller, ActiveJob and Plain ruby classes are the case now**
 - [x] Develop an extensible schema for formatting the messages. **A serializer is introduced**
 - [x] Cover the existing code with specs. **Coverage increased to 100%**
 - [ ] Consider using batch publishing in case the load is high (how do we measure this, perhaps rpm?)
 - [ ] Consider using JSON schema to validate the input for publisher
 - [ ] Consider enabling an option to publish to multiple topics. Do we need to publish to multiple topics?
 - [ ] Consider adding state to message dispatcher and instantiate it on every event
 - [ ] Consider using `::ActiveJob::Base.around_perform` or `::ActiveJob::Base.around_enqueue` in case we need to track all jobs.
 - [ ] Figure out the params for plain ruby class context handler.
 - [ ] Consider `ContextHandlers::ActiveJob` params. How to deal with \_args? It won't necessarily respond to `#as_json`.