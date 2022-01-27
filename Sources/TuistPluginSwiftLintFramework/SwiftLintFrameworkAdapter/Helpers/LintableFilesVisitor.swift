import Foundation
import SwiftLintFramework

#warning("TODO: needs documentation")
#warning("TODO: unit tests")

struct LintableFilesVisitor {
    let paths: [String]
    let quiet: Bool
    let cache: LinterCache?
    let parallel: Bool
    let block: (CollectedLinter) -> Void

    init(
        paths: [String],
        quiet: Bool,
        cache: LinterCache?,
        block: @escaping (CollectedLinter) -> Void
    ) {
        self.paths = resolveParamsFiles(args: paths)
        self.quiet = quiet
        self.cache = cache
        self.parallel = true
        self.block = block
    }

    func linter(forFile file: SwiftLintFile, configuration: Configuration) -> Linter {
        Linter(file: file, configuration: configuration, cache: cache)
    }
}

// MARK: - Helpers

private func resolveParamsFiles(args: [String]) -> [String] {
    return args.reduce(into: []) { (allArgs: inout [String], arg: String) -> Void in
        if arg.hasPrefix("@"), let contents = try? String(contentsOfFile: String(arg.dropFirst())) {
            allArgs.append(contentsOf: resolveParamsFiles(args: contents.split(separator: "\n").map(String.init)))
        } else {
            allArgs.append(arg)
        }
    }
}
