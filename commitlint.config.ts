import type { UserConfig } from '@commitlint/types'

export const Configuration: UserConfig = {
    extends: ['@commitlint/config-conventional'],
    rules: {
        "type-enum": [
            2,
            "always",
            [
                "build",
                "chore",
                "ci",
                "docs",
                "feat",
                "fix",
                "refactor",
                "revert",
                "style",
                "test",
                "gas", // extended: gas optimization
            ],
        ],
    },
}

module.exports = Configuration