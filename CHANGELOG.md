# Changelog

### 0.1.14
* Allows autodiscovering of the context handlers and Rails development env autoreload.

### 0.1.13
* Removes obsolete rails pre-configuration for the sake of default configuration settings

### 0.1.12
* Delegates STDOUT adapter to configured logger first. If logger is not set, delegates the output to STDOUT

### 0.1.11
* Removes the annoying warnings in logs

### 0.1.10
Switch from Spicerack::Configurable to Spicerack::Directive

### 0.1.9
* Pass all attributes in the data field instead of attributes field for google cloud. Attributes field did not allow nested objects, which data field allows. See google pub sub documentation for more reference.

### 0.1.8
* Switch auto target initialization to false

### 0.1.7 2020/01/20
* Adds a config option to allow explicit adapter setup.
* Adds an `after_initialize` rails hook to setup adapters.
* Remove topic from the list of Google Cloud adapter arguments.

### 0.1.6 2020/01/17
* Allow topic to be explicitly set upon Google Cloud adapter initialization

### 0.1.5 2020/01/13
* In case `graceful_error_handling` is set to off raise a generic `Stenotype::Error` on any exception in order to intercept a single error type in the client code.
* Adds an `at_exit` hook to flush the async message queue when using the library in async mode.

### 0.1.4 2020/01/10
* Adds a new configuration option `graceful_error_handling` to suppress errors raised from the gem's internals yet logging the error to specified `config.logger`

### 0.1.3: 2020/01/10
* Adds a new configuration option `logger` to use during error handling
* Adds a new config option `Stenotype.config.enabled`. If the option is set to false then event is not going to be published. The option is `true` by default.

### 0.1.2: 2019/12/10

* Changes the interface of how event is emitted. Now you must pass `event_name`, `attributes` and optional `eval_context`. Note that `additional_options` are eliminated
* Makes StdoutAdapter more informative by adding a special line for every entry in the log.
* Fixes Rails initializer not working after switching to Configurable from Spicerack.

### 0.1.1: 2019/11/25

* Moves all error into top level namespace definition file.
* Introduces a root class for all gem specific errors.
* Renames ObjectExt to an Eventable concern.
* Changes the aggressive extension of Object, forces a user to include the Eventable module only where necessary.
* Moves all rails specific logic into a Railtie, which is required only if in Rails universe.
* Adds more examples to yard documentation of the classes.
* Adds a TODO list based on the feedback.
* Grinds a huge GoogleCloud adapter method into smaller ones.
* Add two 'on/off' configuration options for Rails specific components.
* Switches to using rails specific delegate method where possible (in rails components extensions).

### 0.1.0: The Big Bang

* Rails controller and active job adapters
* Generic event method
* Handlers for GCP Pub/Sub and STDOUT
* Initial commit



