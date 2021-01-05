# Nexus Unit Testing Plugin
Nexus Unit Testing Plugin provides a user interface
for running tests with either [Nexus Unit Testing](https://github.com/thenexusavenger/nexus-unit-testing)
or [TestEZ](https://github.com/Roblox/testez). Included
is a viewer for individual tests and an output viewer that
is isolated for each unit test.

## Installing
### Roblox Plugin Marketplace
The plugin can be found on the Plugin Marketplace.
<br>https://www.roblox.com/library/4735386072/Nexus-Unit-Testing-Plugin

### Rojo / Nexus Git
This repository can be synced into Roblox Studio using 
[Rojo (0.5)](https://github.com/rojo-rbx/rojo)
or [Nexus Git](https://github.com/TheNexusAvenger/Nexus-Git).
Look at the respective repositories for how to use them.

## Known Problems
### Rerunning tests doesn't reselect tests
When rerunning tests with tests selected, the list frames for
the tests won't be selected after rerunning. This requires
a feature added to Nexus Plugin Framework since the same code
that deselects a list frame when you click without pressing `Ctrl`
or `Shift` prevents the code from selecting multiple frames.

### Memory leak after running a lot of tests
After running a lot of tests, the memory usage of Roblox Studio
will appear to increase without ever going down. Nexus Plugin
Framework is missing some features to properly clear resources.
This will be resolved in the next version, but will require some
work with the plugin to update.

### Nested tests don't select correctly
When selecting tests without pressing `Ctrl` or `Shift`, the
current selected test is deselected. If a test is nested in another
test, this doesn't happen. This may be a problem with Nexus Plugin
Framework.

## License
Nexus Unit Testing Plugin is available under the terms of the MIT 
License. See [LICENSE](LICENSE) for details.