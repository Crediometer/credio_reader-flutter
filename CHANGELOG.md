## 0.0.5

## Version 0.0.5 - 2024-10-02

### Added
- Customizable amount input: Developers can now customize the appearance of the amount input field.
- Predefined amount option: Added ability to set a predefined amount, which skips the amount input screen.
- Customizable account type selection: Introduced a new `customSelectionSheet` option in `CredioConfig` for custom account type selection UI.
- Customizable PIN entry: Added `customPinEntry` option in `CredioConfig` for custom PIN entry UI.
- Customizable loader: Introduced `customLoader` in `CredioConfig` for custom loading and error handling during transactions.

### Changed
- Enhanced error handling in custom loaders to provide a more consistent user experience.
- Updated `CredioConfig` to include new customization options.
- Refactored `WithdrawalScreen` and `PinInputScreen` to support new customization features.

### Improved
- Better type safety and error reporting in customizable components.
- More flexible UI customization options throughout the payment flow.