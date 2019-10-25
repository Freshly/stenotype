# Freshly-events TODO list

 - [ ] Figure out how to pass context to data publisher
 - [ ] Switch from synchronous to asynchronous message publishing
 - [ ] Consider using batch publishing in case the load is high (how do we measure this, perhaps rpm?)
 - [ ] Figure out how to unwind from using a specific framework (e.g Rails), but rather implement events in a general way suitable for plain ruby classes
 - [ ] Infer data in extensible way. Given a common context implement context handlers capable of fetching data for specific cases (Controller, ActiveJobs, Models, etc.)
 - [ ] Figure out the most common default context handlers (Controller, something else)
 - [ ] Develop an extensible schema for formatting the messages
 - [ ] Consider using JSON schema to validate the input for publisher
 - [ ] Cover the existing code with specs
 - [ ] Consider enabling an option to publish to multiple topics
 - [ ] Consider adding state to message dispatcher and instantiate it on every event
