import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
    Locale('pt', 'BR'),
  ];

  /// No description provided for @appName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Supermarket Tracker'**
  String get appName;

  /// No description provided for @loginTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entrar'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Informe suas credenciais para continuar'**
  String get loginSubtitle;

  /// No description provided for @loginUsername.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usuário'**
  String get loginUsername;

  /// No description provided for @loginPassword.
  ///
  /// In pt_BR, this message translates to:
  /// **'Senha'**
  String get loginPassword;

  /// No description provided for @loginSubmit.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entrar'**
  String get loginSubmit;

  /// No description provided for @loginErrorEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Informe usuário e senha'**
  String get loginErrorEmpty;

  /// No description provided for @dashboardTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Painel'**
  String get dashboardTitle;

  /// No description provided for @dashboardRevenue.
  ///
  /// In pt_BR, this message translates to:
  /// **'Vendido no mês'**
  String get dashboardRevenue;

  /// No description provided for @dashboardProfit.
  ///
  /// In pt_BR, this message translates to:
  /// **'Lucro no mês'**
  String get dashboardProfit;

  /// No description provided for @dashboardLoss.
  ///
  /// In pt_BR, this message translates to:
  /// **'Prejuízo no mês'**
  String get dashboardLoss;

  /// No description provided for @dashboardTicket.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ticket médio'**
  String get dashboardTicket;

  /// No description provided for @dashboardSalesToday.
  ///
  /// In pt_BR, this message translates to:
  /// **'Vendas do dia'**
  String get dashboardSalesToday;

  /// No description provided for @dashboardSalesMonth.
  ///
  /// In pt_BR, this message translates to:
  /// **'Vendas do mês'**
  String get dashboardSalesMonth;

  /// No description provided for @dashboardLatestSales.
  ///
  /// In pt_BR, this message translates to:
  /// **'Últimas vendas'**
  String get dashboardLatestSales;

  /// No description provided for @dashboardTopProducts.
  ///
  /// In pt_BR, this message translates to:
  /// **'Produtos mais vendidos'**
  String get dashboardTopProducts;

  /// No description provided for @dashboardLowStock.
  ///
  /// In pt_BR, this message translates to:
  /// **'Estoque baixo'**
  String get dashboardLowStock;

  /// No description provided for @storesTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Lojas'**
  String get storesTitle;

  /// No description provided for @newStore.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nova loja'**
  String get newStore;

  /// No description provided for @storeDetailTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Detalhes da loja'**
  String get storeDetailTitle;

  /// No description provided for @storeCode.
  ///
  /// In pt_BR, this message translates to:
  /// **'Código'**
  String get storeCode;

  /// No description provided for @storeName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nome'**
  String get storeName;

  /// No description provided for @storeCompany.
  ///
  /// In pt_BR, this message translates to:
  /// **'Empresa'**
  String get storeCompany;

  /// No description provided for @storeStatus.
  ///
  /// In pt_BR, this message translates to:
  /// **'Status'**
  String get storeStatus;

  /// No description provided for @noStores.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhuma loja cadastrada'**
  String get noStores;

  /// No description provided for @storeCreated.
  ///
  /// In pt_BR, this message translates to:
  /// **'Loja criada com sucesso'**
  String get storeCreated;

  /// No description provided for @navSales.
  ///
  /// In pt_BR, this message translates to:
  /// **'Vendas'**
  String get navSales;

  /// No description provided for @navProducts.
  ///
  /// In pt_BR, this message translates to:
  /// **'Produtos'**
  String get navProducts;

  /// No description provided for @navStock.
  ///
  /// In pt_BR, this message translates to:
  /// **'Estoque'**
  String get navStock;

  /// No description provided for @navCash.
  ///
  /// In pt_BR, this message translates to:
  /// **'Caixa'**
  String get navCash;

  /// No description provided for @navCustomers.
  ///
  /// In pt_BR, this message translates to:
  /// **'Clientes'**
  String get navCustomers;

  /// No description provided for @navUsers.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usuários'**
  String get navUsers;

  /// No description provided for @navCompany.
  ///
  /// In pt_BR, this message translates to:
  /// **'Empresa'**
  String get navCompany;

  /// No description provided for @navMore.
  ///
  /// In pt_BR, this message translates to:
  /// **'Mais'**
  String get navMore;

  /// No description provided for @save.
  ///
  /// In pt_BR, this message translates to:
  /// **'Salvar'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @comingSoon.
  ///
  /// In pt_BR, this message translates to:
  /// **'Em breve'**
  String get comingSoon;

  /// No description provided for @comingSoonMessage.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esta seção ainda está em desenvolvimento.'**
  String get comingSoonMessage;

  /// No description provided for @genericError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Algo deu errado'**
  String get genericError;

  /// No description provided for @retry.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tentar novamente'**
  String get retry;

  /// No description provided for @requiredField.
  ///
  /// In pt_BR, this message translates to:
  /// **'Campo obrigatório'**
  String get requiredField;

  /// No description provided for @noProducts.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum produto cadastrado'**
  String get noProducts;

  /// No description provided for @productCreated.
  ///
  /// In pt_BR, this message translates to:
  /// **'Produto criado com sucesso'**
  String get productCreated;

  /// No description provided for @productName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nome'**
  String get productName;

  /// No description provided for @productBarcode.
  ///
  /// In pt_BR, this message translates to:
  /// **'Código de barras'**
  String get productBarcode;

  /// No description provided for @productSalePrice.
  ///
  /// In pt_BR, this message translates to:
  /// **'Preço de venda'**
  String get productSalePrice;

  /// No description provided for @productPurchasePrice.
  ///
  /// In pt_BR, this message translates to:
  /// **'Preço de compra'**
  String get productPurchasePrice;

  /// No description provided for @productMinStock.
  ///
  /// In pt_BR, this message translates to:
  /// **'Estoque mínimo'**
  String get productMinStock;

  /// No description provided for @productCurrentStock.
  ///
  /// In pt_BR, this message translates to:
  /// **'Estoque atual'**
  String get productCurrentStock;

  /// No description provided for @productStatus.
  ///
  /// In pt_BR, this message translates to:
  /// **'Status'**
  String get productStatus;

  /// No description provided for @newProduct.
  ///
  /// In pt_BR, this message translates to:
  /// **'Novo produto'**
  String get newProduct;

  /// No description provided for @productDetailTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Detalhes do produto'**
  String get productDetailTitle;

  /// No description provided for @noCustomers.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum cliente cadastrado'**
  String get noCustomers;

  /// No description provided for @customerCreated.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cliente criado com sucesso'**
  String get customerCreated;

  /// No description provided for @customerName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nome'**
  String get customerName;

  /// No description provided for @customerCpfCnpj.
  ///
  /// In pt_BR, this message translates to:
  /// **'CPF/CNPJ'**
  String get customerCpfCnpj;

  /// No description provided for @customerEmail.
  ///
  /// In pt_BR, this message translates to:
  /// **'E-mail'**
  String get customerEmail;

  /// No description provided for @customerPhone.
  ///
  /// In pt_BR, this message translates to:
  /// **'Telefone'**
  String get customerPhone;

  /// No description provided for @customerBirthDate.
  ///
  /// In pt_BR, this message translates to:
  /// **'Data de nascimento'**
  String get customerBirthDate;

  /// No description provided for @customerStatus.
  ///
  /// In pt_BR, this message translates to:
  /// **'Status'**
  String get customerStatus;

  /// No description provided for @newCustomer.
  ///
  /// In pt_BR, this message translates to:
  /// **'Novo cliente'**
  String get newCustomer;

  /// No description provided for @customerDetailTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Detalhes do cliente'**
  String get customerDetailTitle;

  /// No description provided for @noUsers.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum usuário cadastrado'**
  String get noUsers;

  /// No description provided for @userCreated.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usuário criado com sucesso'**
  String get userCreated;

  /// No description provided for @userName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nome'**
  String get userName;

  /// No description provided for @userEmail.
  ///
  /// In pt_BR, this message translates to:
  /// **'E-mail'**
  String get userEmail;

  /// No description provided for @userPhone.
  ///
  /// In pt_BR, this message translates to:
  /// **'Telefone'**
  String get userPhone;

  /// No description provided for @userStatus.
  ///
  /// In pt_BR, this message translates to:
  /// **'Status'**
  String get userStatus;

  /// No description provided for @newUser.
  ///
  /// In pt_BR, this message translates to:
  /// **'Novo usuário'**
  String get newUser;

  /// No description provided for @userDetailTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Detalhes do usuário'**
  String get userDetailTitle;

  /// No description provided for @noStockMovements.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhuma movimentação de estoque cadastrada'**
  String get noStockMovements;

  /// No description provided for @noSales.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhuma venda cadastrada'**
  String get noSales;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
