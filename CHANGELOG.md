## 0.0.3

## Version 0.0.3 - 2024-08-14

### Added
- New `locator` parameter in `CredioConfig` for improved navigation handling.
- `initializerButton` parameter in `CredioConfig` to allow custom initializer button widgets.
- `ButtonConfiguration` class for customizing the appearance of the ReaderButton.

### Changed
- `CredioConfig` constructor now requires `apiKey`, `terminalId`, `webhookURL`, and `locator` as positional parameters.
- `companyColor` parameter removed from `CredioConfig`. Use `buttonConfiguration` for button styling instead.

### Deprecated
- `companyColor` parameter in `CredioConfig` is no longer used.

### Removed
- `directDebit` parameter from `CredioConfig` as it's no longer needed.

### Fixed
- Improved type safety by making `terminalId` and `webhookURL` non-nullable.