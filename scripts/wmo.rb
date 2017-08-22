require "Xcodeproj"

project = Xcodeproj::Project.open("Drrrible.xcodeproj")
target = project.targets.find.find { |t| t.name == "Drrrible" }
build_settings = target.build_settings("Debug")
build_settings["SWIFT_OPTIMIZATION_LEVEL"] = "-Owholemodule"
project.save
