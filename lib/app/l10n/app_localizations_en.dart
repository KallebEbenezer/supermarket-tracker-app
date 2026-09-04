// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Supermarket Tracker';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get loginSubtitle => 'Enter your credentials to continue';

  @override
  String get loginUsername => 'Username';

  @override
  String get loginPassword => 'Password';

  @override
  String get loginSubmit => 'Sign in';

  @override
  String get loginErrorEmpty => 'Enter username and password';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardRevenue => 'Sold this month';

  @override
  String get dashboardProfit => 'Profit this month';

  @override
  String get dashboardLoss => 'Loss this month';

  @override
  String get dashboardTicket => 'Average ticket';

  @override
  String get dashboardSalesToday => 'Sales today';

  @override
  String get dashboardSalesMonth => 'Sales this month';

  @override
  String get dashboardLatestSales => 'Latest sales';

  @override
  String get dashboardTopProducts => 'Top selling products';

  @override
  String get dashboardLowStock => 'Low stock';

  @override
  String get storesTitle => 'Stores';

  @override
  String get newStore => 'New store';

  @override
  String get storeDetailTitle => 'Store details';

  @override
  String get storeCode => 'Code';

  @override
  String get storeName => 'Name';

  @override
  String get storeCompany => 'Company';

  @override
  String get storeStatus => 'Status';

  @override
  String get noStores => 'No stores registered';

  @override
  String get storeCreated => 'Store created successfully';

  @override
  String get navSales => 'Sales';

  @override
  String get navProducts => 'Products';

  @override
  String get navStock => 'Stock';

  @override
  String get navCash => 'Cash';

  @override
  String get navCustomers => 'Customers';

  @override
  String get navUsers => 'Users';

  @override
  String get navCompany => 'Company';

  @override
  String get navMore => 'More';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get comingSoonMessage => 'This section is still under development.';

  @override
  String get genericError => 'Something went wrong';

  @override
  String get retry => 'Try again';

  @override
  String get requiredField => 'Required field';

  @override
  String get noProducts => 'No products registered';

  @override
  String get productCreated => 'Product created successfully';

  @override
  String get productUpdated => 'Product updated successfully';

  @override
  String get editProduct => 'Edit product';

  @override
  String get productName => 'Name';

  @override
  String get productBarcode => 'Barcode';

  @override
  String get productSalePrice => 'Sale price';

  @override
  String get productPurchasePrice => 'Purchase price';

  @override
  String get productMinStock => 'Minimum stock';

  @override
  String get productCurrentStock => 'Current stock';

  @override
  String get productStatus => 'Status';

  @override
  String get newProduct => 'New product';

  @override
  String get productDetailTitle => 'Product details';

  @override
  String get noCustomers => 'No customers registered';

  @override
  String get customerCreated => 'Customer created successfully';

  @override
  String get customerName => 'Name';

  @override
  String get customerCpfCnpj => 'CPF/CNPJ';

  @override
  String get customerEmail => 'Email';

  @override
  String get customerPhone => 'Phone';

  @override
  String get customerBirthDate => 'Birth date';

  @override
  String get customerStatus => 'Status';

  @override
  String get newCustomer => 'New customer';

  @override
  String get customerDetailTitle => 'Customer details';

  @override
  String get noUsers => 'No users registered';

  @override
  String get userCreated => 'User created successfully';

  @override
  String get userName => 'Name';

  @override
  String get userEmail => 'Email';

  @override
  String get userPhone => 'Phone';

  @override
  String get userStatus => 'Status';

  @override
  String get newUser => 'New user';

  @override
  String get userDetailTitle => 'User details';

  @override
  String get noStockMovements => 'No stock movements registered';

  @override
  String get noSales => 'No sales registered';

  @override
  String get drawerLogout => 'Sign out';

  @override
  String get loginForgotPassword => 'Forgot password?';

  @override
  String get loginNoAccount => 'Don\'t have an account?';

  @override
  String get signupTitle => 'Sign up';

  @override
  String get signupErrorEmpty => 'Fill in all required fields';

  @override
  String get signupSubtitle => 'Create your account to continue';

  @override
  String get signupName => 'Full name';

  @override
  String get signupPhone => 'Phone';

  @override
  String get signupSubmit => 'Sign up';

  @override
  String get signupHasAccount => 'Already have an account?';

  @override
  String get forgotTitle => 'Forgot password';

  @override
  String get forgotSubtitle => 'Enter your email to receive a reset link';

  @override
  String get forgotSubmit => 'Send link';

  @override
  String get forgotSuccess => 'Reset link sent! Check your email.';

  @override
  String get forgotBackToLogin => 'Back to sign in';

  @override
  String get resetTitle => 'Reset password';

  @override
  String get resetSubtitle =>
      'Enter the token from your email and your new password';

  @override
  String get resetToken => 'Token';

  @override
  String get resetSubmit => 'Reset password';

  @override
  String get resetSuccess => 'Password reset successfully!';

  @override
  String get noCashRegisters => 'No cash registers registered';

  @override
  String get cashRegisterName => 'Cash register name';

  @override
  String get cashRegisterCreated => 'Cash register created successfully';

  @override
  String get cashRegisterActions => 'Cash register actions';

  @override
  String get cashSessionOpen => 'Open session';

  @override
  String get cashSessionClose => 'Close session';

  @override
  String get cashSessionOpened => 'Session opened successfully';

  @override
  String get cashSessionClosed => 'Session closed successfully';

  @override
  String get cashOpeningValue => 'Opening value';

  @override
  String get cashClosingValue => 'Closing value';

  @override
  String get cashObservation => 'Observation';

  @override
  String get validationNameRequired => 'Enter your name';

  @override
  String get validationNameMinLength => 'Name must be at least 3 characters';

  @override
  String get validationEmailRequired => 'Enter your email';

  @override
  String get validationEmailInvalid => 'Invalid email';

  @override
  String get validationPasswordRequired => 'Enter your password';

  @override
  String get validationPasswordMinLength =>
      'Password must be at least 6 characters';

  @override
  String get noCompany => 'No company found';

  @override
  String get noCompanyMessage => 'Create a company to start using the system.';

  @override
  String get createCompany => 'Create company';

  @override
  String get scanBarcode => 'Scan barcode';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get productPhoto => 'Product photo';

  @override
  String get saleQueue => 'Item queue';

  @override
  String get finishSale => 'Finish sale';

  @override
  String get editSale => 'Edit sale';

  @override
  String get removeItem => 'Remove item';

  @override
  String get pixQrCode => 'PIX QR Code';

  @override
  String get bankAccount => 'Bank account';

  @override
  String get bankName => 'Bank name';

  @override
  String get bankAgency => 'Agency';

  @override
  String get bankAccountNumber => 'Account number';

  @override
  String get bankAccountType => 'Account type';

  @override
  String get bankAccountHolder => 'Account holder';

  @override
  String get bankAccountDocument => 'Holder document';

  @override
  String get pixKey => 'PIX key';

  @override
  String get bankCurrent => 'Checking';

  @override
  String get bankSavings => 'Savings';

  @override
  String get bankPayment => 'Payment';

  @override
  String get linkBankAccount => 'Link bank account';

  @override
  String get bankAccountLinked => 'Bank account linked successfully';

  @override
  String get noBankAccounts => 'No bank accounts registered';

  @override
  String get createBankAccountMessage =>
      'Create a bank account to start receiving payments.';

  @override
  String get bankAccountRequired => 'Select a bank account to generate the PIX';

  @override
  String get bankAccountCreated => 'Bank account created successfully';

  @override
  String get bankAccountUpdated => 'Bank account updated successfully';

  @override
  String get bankAccountDeleted => 'Bank account deleted successfully';

  @override
  String get editBankAccount => 'Edit bank account';

  @override
  String get principalAccount => 'Primary account';

  @override
  String get selectBank => 'Select a bank';

  @override
  String get cashSessionActive => 'Active session';

  @override
  String get cashSessionRequired =>
      'Open a cash session before finalizing the sale';

  @override
  String get cashSessionHistory => 'Session history';

  @override
  String get stockIn => 'Entry';

  @override
  String get stockOut => 'Exit';

  @override
  String get stockAdjust => 'Adjustment';

  @override
  String get stockSale => 'Sale';

  @override
  String get stockCancellation => 'Cancellation';

  @override
  String get registerStock => 'Register movement';

  @override
  String get stockMovementCreated => 'Movement registered successfully';

  @override
  String get stockMovementTitle => 'Stock Movements';

  @override
  String get stockMovementType => 'Type';

  @override
  String get stockMovementQuantity => 'Quantity';

  @override
  String get stockMovementReason => 'Reason';

  @override
  String get stockMovementProduct => 'Product';

  @override
  String get selectProduct => 'Select a product';

  @override
  String get selectType => 'Select a type';

  @override
  String get stockMovementQuantityHint => 'Enter the quantity';

  @override
  String get stockMovementReasonHint => 'Optional reason';

  @override
  String get barcodeScanTitle => 'Scan barcode';

  @override
  String get barcodeScanInstruction =>
      'Position the barcode within the camera view';

  @override
  String get barcodeScanHint => 'Position the barcode in the indicated area';

  @override
  String get barcodeManualEntry => 'Enter manually';

  @override
  String get barcodeScanError => 'Could not read the barcode';

  @override
  String get photoCaptureTitle => 'Take product photo';

  @override
  String get photoCaptureInstruction =>
      'Position the product in the camera to take the photo';

  @override
  String get retakePhoto => 'Retake photo';

  @override
  String get usePhoto => 'Use photo';

  @override
  String get skipPhoto => 'Skip photo';

  @override
  String get photoAttached => 'Photo attached';

  @override
  String get noPhotoAttached => 'No photo attached';

  @override
  String get addPhoto => 'Add photo';

  @override
  String get newSale => 'New sale';

  @override
  String get saleSummary => 'Sale summary';

  @override
  String get subtotal => 'Subtotal';

  @override
  String get total => 'Total';

  @override
  String get quantity => 'Qty';

  @override
  String get unitPrice => 'Unit price';

  @override
  String get productNotFound => 'Product not found for this barcode';

  @override
  String get barcodeNotFound => 'No product found for this barcode';

  @override
  String get emptyQueue => 'Scan products to start a sale';

  @override
  String get saleFinalized => 'Sale finalized successfully';

  @override
  String get saleFinalizing => 'Finalizing sale...';

  @override
  String get copyPixCode => 'Copy PIX code';

  @override
  String get pixCodeCopied => 'PIX code copied';

  @override
  String get newSaleCta => 'Tap the button below to start scanning products';

  @override
  String get close => 'Close';

  @override
  String get confirm => 'Confirm';

  @override
  String get saleNumber => 'Sale #';

  @override
  String get companyCreated => 'Company created successfully';

  @override
  String get companyRazaoSocial => 'Legal name';

  @override
  String get companyNomeFantasia => 'Trade name';

  @override
  String get companyCnpj => 'CNPJ';

  @override
  String get validationCnpjInvalid => 'CNPJ must contain 14 digits';

  @override
  String get selectingStore => 'Selecting store...';

  @override
  String get createStoreMessage => 'Create a store to start using the system.';

  @override
  String get storeSelected => 'Store selected successfully';

  @override
  String get createCashRegisterMessage =>
      'Create a cash register to start recording sales.';

  @override
  String get nfcAvailable => 'NFC available';

  @override
  String get nfcUnavailable => 'NFC not available on this device';

  @override
  String get nfcReading => 'Waiting for card...';

  @override
  String get nfcReadSuccess => 'Card read successfully';

  @override
  String get nfcTagId => 'Card UID';

  @override
  String get nfcReadError => 'Error reading card';

  @override
  String get pixPolling => 'Checking PIX payment';

  @override
  String get pixWaiting => 'Waiting for payment...';

  @override
  String get pixApproved => 'Payment approved!';

  @override
  String get pixDeclined => 'Payment declined';

  @override
  String get pixTimeout => 'Timed out waiting for payment';

  @override
  String get pollingElapsed => 'Elapsed:';

  @override
  String get retryPolling => 'Try again';

  @override
  String get paymentMethod => 'Payment method';

  @override
  String get paymentPix => 'PIX';

  @override
  String get paymentCard => 'Card';

  @override
  String get paymentCash => 'Cash';

  @override
  String get paymentAmount => 'Payment amount';

  @override
  String get amountReceived => 'Amount received';

  @override
  String get change => 'Change';

  @override
  String get changeAmount => 'Change';

  @override
  String get addPayment => 'Add payment';

  @override
  String get removePayment => 'Remove payment';

  @override
  String get splitPayment => 'Split payment';

  @override
  String get remaining => 'Remaining';

  @override
  String get totalPaid => 'Total paid';

  @override
  String get totalDue => 'Total due';

  @override
  String get cardType => 'Card type';

  @override
  String get cardDebit => 'Debit';

  @override
  String get cardCredit => 'Credit';

  @override
  String get installments => 'Installments';

  @override
  String get nfcRead => 'Tap card';

  @override
  String get nfcReadAgain => 'Read again';

  @override
  String get nfcTapCard => 'Tap your card on the device';

  @override
  String get confirmPayment => 'Confirm payment';

  @override
  String get processing => 'Processing...';

  @override
  String get approved => 'Approved';

  @override
  String get declined => 'Declined';

  @override
  String get saleConfirmed => 'Sale confirmed';

  @override
  String get backToSales => 'Back to sales';

  @override
  String get paymentMethods => 'Payment methods';

  @override
  String get paymentIncomplete =>
      'Incomplete payment. Add payments to cover the total.';

  @override
  String get pixQrCodeHint =>
      'QR Code will be generated after sale finalization';

  @override
  String get pixQrCodeError => 'Unable to generate QR Code';

  @override
  String get productAlreadyScanned =>
      'This product has already been scanned in this session';
}
