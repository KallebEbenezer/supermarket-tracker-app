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

  /// No description provided for @productUpdated.
  ///
  /// In pt_BR, this message translates to:
  /// **'Produto atualizado com sucesso'**
  String get productUpdated;

  /// No description provided for @editProduct.
  ///
  /// In pt_BR, this message translates to:
  /// **'Editar produto'**
  String get editProduct;

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

  /// No description provided for @productBarcodeHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Opcional - será gerado automaticamente se vazio'**
  String get productBarcodeHint;

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

  /// No description provided for @drawerLogout.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sair'**
  String get drawerLogout;

  /// No description provided for @loginForgotPassword.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esqueceu a senha?'**
  String get loginForgotPassword;

  /// No description provided for @loginNoAccount.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não tem conta?'**
  String get loginNoAccount;

  /// No description provided for @signupTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cadastrar'**
  String get signupTitle;

  /// No description provided for @signupErrorEmpty.
  ///
  /// In pt_BR, this message translates to:
  /// **'Preencha todos os campos obrigatórios'**
  String get signupErrorEmpty;

  /// No description provided for @signupSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Crie sua conta para continuar'**
  String get signupSubtitle;

  /// No description provided for @signupName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nome completo'**
  String get signupName;

  /// No description provided for @signupPhone.
  ///
  /// In pt_BR, this message translates to:
  /// **'Telefone'**
  String get signupPhone;

  /// No description provided for @signupSubmit.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cadastrar'**
  String get signupSubmit;

  /// No description provided for @signupHasAccount.
  ///
  /// In pt_BR, this message translates to:
  /// **'Já tem conta?'**
  String get signupHasAccount;

  /// No description provided for @forgotTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Esqueceu a senha'**
  String get forgotTitle;

  /// No description provided for @forgotSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Informe seu e-mail para receber o link de redefinição'**
  String get forgotSubtitle;

  /// No description provided for @forgotSubmit.
  ///
  /// In pt_BR, this message translates to:
  /// **'Enviar link'**
  String get forgotSubmit;

  /// No description provided for @forgotSuccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'Link enviado! Verifique seu e-mail.'**
  String get forgotSuccess;

  /// No description provided for @forgotBackToLogin.
  ///
  /// In pt_BR, this message translates to:
  /// **'Voltar para o login'**
  String get forgotBackToLogin;

  /// No description provided for @resetTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Redefinir senha'**
  String get resetTitle;

  /// No description provided for @resetSubtitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Informe o token do seu e-mail e a nova senha'**
  String get resetSubtitle;

  /// No description provided for @resetToken.
  ///
  /// In pt_BR, this message translates to:
  /// **'Token'**
  String get resetToken;

  /// No description provided for @resetSubmit.
  ///
  /// In pt_BR, this message translates to:
  /// **'Redefinir senha'**
  String get resetSubmit;

  /// No description provided for @resetSuccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'Senha redefinida com sucesso!'**
  String get resetSuccess;

  /// No description provided for @noCashRegisters.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum caixa cadastrado'**
  String get noCashRegisters;

  /// No description provided for @cashRegisterName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nome do caixa'**
  String get cashRegisterName;

  /// No description provided for @cashRegisterCreated.
  ///
  /// In pt_BR, this message translates to:
  /// **'Caixa criado com sucesso'**
  String get cashRegisterCreated;

  /// No description provided for @cashRegisterActions.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ações do caixa'**
  String get cashRegisterActions;

  /// No description provided for @cashSessionOpen.
  ///
  /// In pt_BR, this message translates to:
  /// **'Abrir sessão'**
  String get cashSessionOpen;

  /// No description provided for @cashSessionClose.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fechar sessão'**
  String get cashSessionClose;

  /// No description provided for @cashSessionOpened.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sessão aberta com sucesso'**
  String get cashSessionOpened;

  /// No description provided for @cashSessionClosed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sessão fechada com sucesso'**
  String get cashSessionClosed;

  /// No description provided for @cashOpeningValue.
  ///
  /// In pt_BR, this message translates to:
  /// **'Valor de abertura'**
  String get cashOpeningValue;

  /// No description provided for @cashClosingValue.
  ///
  /// In pt_BR, this message translates to:
  /// **'Valor de fechamento'**
  String get cashClosingValue;

  /// No description provided for @cashObservation.
  ///
  /// In pt_BR, this message translates to:
  /// **'Observação'**
  String get cashObservation;

  /// No description provided for @validationNameRequired.
  ///
  /// In pt_BR, this message translates to:
  /// **'Informe seu nome'**
  String get validationNameRequired;

  /// No description provided for @validationNameMinLength.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nome deve ter pelo menos 3 caracteres'**
  String get validationNameMinLength;

  /// No description provided for @validationEmailRequired.
  ///
  /// In pt_BR, this message translates to:
  /// **'Informe seu e-mail'**
  String get validationEmailRequired;

  /// No description provided for @validationEmailInvalid.
  ///
  /// In pt_BR, this message translates to:
  /// **'E-mail inválido'**
  String get validationEmailInvalid;

  /// No description provided for @validationPasswordRequired.
  ///
  /// In pt_BR, this message translates to:
  /// **'Informe sua senha'**
  String get validationPasswordRequired;

  /// No description provided for @validationPasswordMinLength.
  ///
  /// In pt_BR, this message translates to:
  /// **'Senha deve ter pelo menos 6 caracteres'**
  String get validationPasswordMinLength;

  /// No description provided for @noCompany.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhuma empresa encontrada'**
  String get noCompany;

  /// No description provided for @noCompanyMessage.
  ///
  /// In pt_BR, this message translates to:
  /// **'Crie uma empresa para começar a usar o sistema.'**
  String get noCompanyMessage;

  /// No description provided for @createCompany.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criar empresa'**
  String get createCompany;

  /// No description provided for @scanBarcode.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escanear código de barras'**
  String get scanBarcode;

  /// No description provided for @takePhoto.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tirar foto'**
  String get takePhoto;

  /// No description provided for @productPhoto.
  ///
  /// In pt_BR, this message translates to:
  /// **'Foto do produto'**
  String get productPhoto;

  /// No description provided for @saleQueue.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fila de itens'**
  String get saleQueue;

  /// No description provided for @finishSale.
  ///
  /// In pt_BR, this message translates to:
  /// **'Finalizar venda'**
  String get finishSale;

  /// No description provided for @editSale.
  ///
  /// In pt_BR, this message translates to:
  /// **'Editar venda'**
  String get editSale;

  /// No description provided for @removeItem.
  ///
  /// In pt_BR, this message translates to:
  /// **'Remover item'**
  String get removeItem;

  /// No description provided for @pixQrCode.
  ///
  /// In pt_BR, this message translates to:
  /// **'QR Code PIX'**
  String get pixQrCode;

  /// No description provided for @bankAccount.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conta bancária'**
  String get bankAccount;

  /// No description provided for @bankName.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nome do banco'**
  String get bankName;

  /// No description provided for @bankAgency.
  ///
  /// In pt_BR, this message translates to:
  /// **'Agência'**
  String get bankAgency;

  /// No description provided for @bankAccountNumber.
  ///
  /// In pt_BR, this message translates to:
  /// **'Número da conta'**
  String get bankAccountNumber;

  /// No description provided for @bankAccountType.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tipo de conta'**
  String get bankAccountType;

  /// No description provided for @bankAccountHolder.
  ///
  /// In pt_BR, this message translates to:
  /// **'Titular'**
  String get bankAccountHolder;

  /// No description provided for @bankAccountDocument.
  ///
  /// In pt_BR, this message translates to:
  /// **'Documento do titular'**
  String get bankAccountDocument;

  /// No description provided for @pixKey.
  ///
  /// In pt_BR, this message translates to:
  /// **'Chave PIX'**
  String get pixKey;

  /// No description provided for @bankCurrent.
  ///
  /// In pt_BR, this message translates to:
  /// **'Corrente'**
  String get bankCurrent;

  /// No description provided for @bankSavings.
  ///
  /// In pt_BR, this message translates to:
  /// **'Poupança'**
  String get bankSavings;

  /// No description provided for @bankPayment.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pagamento'**
  String get bankPayment;

  /// No description provided for @linkBankAccount.
  ///
  /// In pt_BR, this message translates to:
  /// **'Vincular conta bancária'**
  String get linkBankAccount;

  /// No description provided for @bankAccountLinked.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conta bancária vinculada com sucesso'**
  String get bankAccountLinked;

  /// No description provided for @noBankAccounts.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhuma conta bancária cadastrada'**
  String get noBankAccounts;

  /// No description provided for @createBankAccountMessage.
  ///
  /// In pt_BR, this message translates to:
  /// **'Crie uma conta bancária para começar a receber pagamentos.'**
  String get createBankAccountMessage;

  /// No description provided for @bankAccountRequired.
  ///
  /// In pt_BR, this message translates to:
  /// **'Selecione uma conta bancária para gerar o PIX'**
  String get bankAccountRequired;

  /// No description provided for @bankAccountCreated.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conta bancária criada com sucesso'**
  String get bankAccountCreated;

  /// No description provided for @bankAccountUpdated.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conta bancária atualizada com sucesso'**
  String get bankAccountUpdated;

  /// No description provided for @bankAccountDeleted.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conta bancária removida com sucesso'**
  String get bankAccountDeleted;

  /// No description provided for @editBankAccount.
  ///
  /// In pt_BR, this message translates to:
  /// **'Editar conta bancária'**
  String get editBankAccount;

  /// No description provided for @principalAccount.
  ///
  /// In pt_BR, this message translates to:
  /// **'Conta principal'**
  String get principalAccount;

  /// No description provided for @selectBank.
  ///
  /// In pt_BR, this message translates to:
  /// **'Selecione um banco'**
  String get selectBank;

  /// No description provided for @cashSessionActive.
  ///
  /// In pt_BR, this message translates to:
  /// **'Sessão ativa'**
  String get cashSessionActive;

  /// No description provided for @cashSessionRequired.
  ///
  /// In pt_BR, this message translates to:
  /// **'Abra uma sessão de caixa antes de finalizar a venda'**
  String get cashSessionRequired;

  /// No description provided for @cashSessionHistory.
  ///
  /// In pt_BR, this message translates to:
  /// **'Histórico de sessões'**
  String get cashSessionHistory;

  /// No description provided for @stockIn.
  ///
  /// In pt_BR, this message translates to:
  /// **'Entrada'**
  String get stockIn;

  /// No description provided for @stockOut.
  ///
  /// In pt_BR, this message translates to:
  /// **'Saída'**
  String get stockOut;

  /// No description provided for @stockAdjust.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ajuste'**
  String get stockAdjust;

  /// No description provided for @stockSale.
  ///
  /// In pt_BR, this message translates to:
  /// **'Venda'**
  String get stockSale;

  /// No description provided for @stockCancellation.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cancelamento'**
  String get stockCancellation;

  /// No description provided for @registerStock.
  ///
  /// In pt_BR, this message translates to:
  /// **'Registrar movimentação'**
  String get registerStock;

  /// No description provided for @stockMovementCreated.
  ///
  /// In pt_BR, this message translates to:
  /// **'Movimentação registrada com sucesso'**
  String get stockMovementCreated;

  /// No description provided for @stockMovementTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Movimentações de Estoque'**
  String get stockMovementTitle;

  /// No description provided for @stockMovementType.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tipo'**
  String get stockMovementType;

  /// No description provided for @stockMovementQuantity.
  ///
  /// In pt_BR, this message translates to:
  /// **'Quantidade'**
  String get stockMovementQuantity;

  /// No description provided for @stockMovementReason.
  ///
  /// In pt_BR, this message translates to:
  /// **'Motivo'**
  String get stockMovementReason;

  /// No description provided for @stockMovementProduct.
  ///
  /// In pt_BR, this message translates to:
  /// **'Produto'**
  String get stockMovementProduct;

  /// No description provided for @selectProduct.
  ///
  /// In pt_BR, this message translates to:
  /// **'Selecione um produto'**
  String get selectProduct;

  /// No description provided for @selectType.
  ///
  /// In pt_BR, this message translates to:
  /// **'Selecione um tipo'**
  String get selectType;

  /// No description provided for @stockMovementQuantityHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Informe a quantidade'**
  String get stockMovementQuantityHint;

  /// No description provided for @stockMovementReasonHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Motivo opcional'**
  String get stockMovementReasonHint;

  /// No description provided for @barcodeScanTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escanear código de barras'**
  String get barcodeScanTitle;

  /// No description provided for @barcodeScanInstruction.
  ///
  /// In pt_BR, this message translates to:
  /// **'Posicione o código de barras dentro da câmera'**
  String get barcodeScanInstruction;

  /// No description provided for @barcodeScanHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'Posicione o código de barras na área indicada'**
  String get barcodeScanHint;

  /// No description provided for @barcodeManualEntry.
  ///
  /// In pt_BR, this message translates to:
  /// **'Digitar manualmente'**
  String get barcodeManualEntry;

  /// No description provided for @barcodeScanError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível ler o código de barras'**
  String get barcodeScanError;

  /// No description provided for @photoCaptureTitle.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tirar foto do produto'**
  String get photoCaptureTitle;

  /// No description provided for @photoCaptureInstruction.
  ///
  /// In pt_BR, this message translates to:
  /// **'Posicione o produto na câmera para tirar a foto'**
  String get photoCaptureInstruction;

  /// No description provided for @retakePhoto.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tirar novamente'**
  String get retakePhoto;

  /// No description provided for @usePhoto.
  ///
  /// In pt_BR, this message translates to:
  /// **'Usar foto'**
  String get usePhoto;

  /// No description provided for @skipPhoto.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pular foto'**
  String get skipPhoto;

  /// No description provided for @photoAttached.
  ///
  /// In pt_BR, this message translates to:
  /// **'Foto anexada'**
  String get photoAttached;

  /// No description provided for @noPhotoAttached.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhuma foto anexada'**
  String get noPhotoAttached;

  /// No description provided for @addPhoto.
  ///
  /// In pt_BR, this message translates to:
  /// **'Adicionar foto'**
  String get addPhoto;

  /// No description provided for @newSale.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nova venda'**
  String get newSale;

  /// No description provided for @saleSummary.
  ///
  /// In pt_BR, this message translates to:
  /// **'Resumo da venda'**
  String get saleSummary;

  /// No description provided for @subtotal.
  ///
  /// In pt_BR, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @total.
  ///
  /// In pt_BR, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @quantity.
  ///
  /// In pt_BR, this message translates to:
  /// **'Qtd'**
  String get quantity;

  /// No description provided for @unitPrice.
  ///
  /// In pt_BR, this message translates to:
  /// **'Preço unitário'**
  String get unitPrice;

  /// No description provided for @productNotFound.
  ///
  /// In pt_BR, this message translates to:
  /// **'Produto não encontrado para este código de barras'**
  String get productNotFound;

  /// No description provided for @barcodeNotFound.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nenhum produto encontrado para este código de barras'**
  String get barcodeNotFound;

  /// No description provided for @emptyQueue.
  ///
  /// In pt_BR, this message translates to:
  /// **'Escanear produtos para iniciar uma venda'**
  String get emptyQueue;

  /// No description provided for @saleFinalized.
  ///
  /// In pt_BR, this message translates to:
  /// **'Venda finalizada com sucesso'**
  String get saleFinalized;

  /// No description provided for @saleFinalizing.
  ///
  /// In pt_BR, this message translates to:
  /// **'Finalizando venda...'**
  String get saleFinalizing;

  /// No description provided for @copyPixCode.
  ///
  /// In pt_BR, this message translates to:
  /// **'Copiar código PIX'**
  String get copyPixCode;

  /// No description provided for @pixCodeCopied.
  ///
  /// In pt_BR, this message translates to:
  /// **'Código PIX copiado'**
  String get pixCodeCopied;

  /// No description provided for @newSaleCta.
  ///
  /// In pt_BR, this message translates to:
  /// **'Toque no botão abaixo para começar a escanear produtos'**
  String get newSaleCta;

  /// No description provided for @close.
  ///
  /// In pt_BR, this message translates to:
  /// **'Fechar'**
  String get close;

  /// No description provided for @confirm.
  ///
  /// In pt_BR, this message translates to:
  /// **'Confirmar'**
  String get confirm;

  /// No description provided for @saleNumber.
  ///
  /// In pt_BR, this message translates to:
  /// **'Venda #'**
  String get saleNumber;

  /// No description provided for @companyCreated.
  ///
  /// In pt_BR, this message translates to:
  /// **'Empresa criada com sucesso'**
  String get companyCreated;

  /// No description provided for @companyRazaoSocial.
  ///
  /// In pt_BR, this message translates to:
  /// **'Razão Social'**
  String get companyRazaoSocial;

  /// No description provided for @companyNomeFantasia.
  ///
  /// In pt_BR, this message translates to:
  /// **'Nome Fantasia'**
  String get companyNomeFantasia;

  /// No description provided for @companyCnpj.
  ///
  /// In pt_BR, this message translates to:
  /// **'CNPJ'**
  String get companyCnpj;

  /// No description provided for @validationCnpjInvalid.
  ///
  /// In pt_BR, this message translates to:
  /// **'CNPJ deve conter 14 dígitos'**
  String get validationCnpjInvalid;

  /// No description provided for @selectingStore.
  ///
  /// In pt_BR, this message translates to:
  /// **'Selecionando loja...'**
  String get selectingStore;

  /// No description provided for @createStoreMessage.
  ///
  /// In pt_BR, this message translates to:
  /// **'Crie uma loja para começar a usar o sistema.'**
  String get createStoreMessage;

  /// No description provided for @createStore.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criar loja'**
  String get createStore;

  /// No description provided for @storeSelected.
  ///
  /// In pt_BR, this message translates to:
  /// **'Loja selecionada com sucesso'**
  String get storeSelected;

  /// No description provided for @createCashRegisterMessage.
  ///
  /// In pt_BR, this message translates to:
  /// **'Crie um caixa para começar a registrar vendas.'**
  String get createCashRegisterMessage;

  /// No description provided for @createCashRegister.
  ///
  /// In pt_BR, this message translates to:
  /// **'Criar caixa'**
  String get createCashRegister;

  /// No description provided for @nfcAvailable.
  ///
  /// In pt_BR, this message translates to:
  /// **'NFC disponível'**
  String get nfcAvailable;

  /// No description provided for @nfcUnavailable.
  ///
  /// In pt_BR, this message translates to:
  /// **'NFC não disponível neste dispositivo'**
  String get nfcUnavailable;

  /// No description provided for @nfcReading.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aguardando cartão...'**
  String get nfcReading;

  /// No description provided for @nfcReadSuccess.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cartão lido com sucesso'**
  String get nfcReadSuccess;

  /// No description provided for @nfcTagId.
  ///
  /// In pt_BR, this message translates to:
  /// **'UID do cartão'**
  String get nfcTagId;

  /// No description provided for @nfcReadError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Erro ao ler cartão'**
  String get nfcReadError;

  /// No description provided for @pixPolling.
  ///
  /// In pt_BR, this message translates to:
  /// **'Verificando pagamento PIX'**
  String get pixPolling;

  /// No description provided for @pixWaiting.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aguardando pagamento...'**
  String get pixWaiting;

  /// No description provided for @pixApproved.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pagamento aprovado!'**
  String get pixApproved;

  /// No description provided for @pixDeclined.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pagamento recusado'**
  String get pixDeclined;

  /// No description provided for @pixTimeout.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tempo esgotado aguardando pagamento'**
  String get pixTimeout;

  /// No description provided for @pollingElapsed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tempo:'**
  String get pollingElapsed;

  /// No description provided for @retryPolling.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tentar novamente'**
  String get retryPolling;

  /// No description provided for @paymentMethod.
  ///
  /// In pt_BR, this message translates to:
  /// **'Forma de pagamento'**
  String get paymentMethod;

  /// No description provided for @paymentPix.
  ///
  /// In pt_BR, this message translates to:
  /// **'PIX'**
  String get paymentPix;

  /// No description provided for @paymentCard.
  ///
  /// In pt_BR, this message translates to:
  /// **'Cartão'**
  String get paymentCard;

  /// No description provided for @paymentCash.
  ///
  /// In pt_BR, this message translates to:
  /// **'Dinheiro'**
  String get paymentCash;

  /// No description provided for @paymentAmount.
  ///
  /// In pt_BR, this message translates to:
  /// **'Valor do pagamento'**
  String get paymentAmount;

  /// No description provided for @amountReceived.
  ///
  /// In pt_BR, this message translates to:
  /// **'Valor recebido'**
  String get amountReceived;

  /// No description provided for @change.
  ///
  /// In pt_BR, this message translates to:
  /// **'Troco'**
  String get change;

  /// No description provided for @changeAmount.
  ///
  /// In pt_BR, this message translates to:
  /// **'Troco'**
  String get changeAmount;

  /// No description provided for @addPayment.
  ///
  /// In pt_BR, this message translates to:
  /// **'Adicionar pagamento'**
  String get addPayment;

  /// No description provided for @removePayment.
  ///
  /// In pt_BR, this message translates to:
  /// **'Remover pagamento'**
  String get removePayment;

  /// No description provided for @splitPayment.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pagamento dividido'**
  String get splitPayment;

  /// No description provided for @remaining.
  ///
  /// In pt_BR, this message translates to:
  /// **'Restante'**
  String get remaining;

  /// No description provided for @totalPaid.
  ///
  /// In pt_BR, this message translates to:
  /// **'Total pago'**
  String get totalPaid;

  /// No description provided for @totalDue.
  ///
  /// In pt_BR, this message translates to:
  /// **'Total a pagar'**
  String get totalDue;

  /// No description provided for @cardType.
  ///
  /// In pt_BR, this message translates to:
  /// **'Tipo de cartão'**
  String get cardType;

  /// No description provided for @cardDebit.
  ///
  /// In pt_BR, this message translates to:
  /// **'Débito'**
  String get cardDebit;

  /// No description provided for @cardCredit.
  ///
  /// In pt_BR, this message translates to:
  /// **'Crédito'**
  String get cardCredit;

  /// No description provided for @installments.
  ///
  /// In pt_BR, this message translates to:
  /// **'Parcelas'**
  String get installments;

  /// No description provided for @nfcRead.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aproximar cartão'**
  String get nfcRead;

  /// No description provided for @nfcReadAgain.
  ///
  /// In pt_BR, this message translates to:
  /// **'Ler novamente'**
  String get nfcReadAgain;

  /// No description provided for @nfcTapCard.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aproxime o cartão do dispositivo'**
  String get nfcTapCard;

  /// No description provided for @confirmPayment.
  ///
  /// In pt_BR, this message translates to:
  /// **'Confirmar pagamento'**
  String get confirmPayment;

  /// No description provided for @processing.
  ///
  /// In pt_BR, this message translates to:
  /// **'Processando...'**
  String get processing;

  /// No description provided for @approved.
  ///
  /// In pt_BR, this message translates to:
  /// **'Aprovado'**
  String get approved;

  /// No description provided for @declined.
  ///
  /// In pt_BR, this message translates to:
  /// **'Negado'**
  String get declined;

  /// No description provided for @saleConfirmed.
  ///
  /// In pt_BR, this message translates to:
  /// **'Venda confirmada'**
  String get saleConfirmed;

  /// No description provided for @backToSales.
  ///
  /// In pt_BR, this message translates to:
  /// **'Voltar às vendas'**
  String get backToSales;

  /// No description provided for @paymentMethods.
  ///
  /// In pt_BR, this message translates to:
  /// **'Formas de pagamento'**
  String get paymentMethods;

  /// No description provided for @paymentIncomplete.
  ///
  /// In pt_BR, this message translates to:
  /// **'Pagamento incompleto. Adicione pagamentos até cobrir o total.'**
  String get paymentIncomplete;

  /// No description provided for @pixQrCodeHint.
  ///
  /// In pt_BR, this message translates to:
  /// **'O QR Code será gerado após a finalização da venda'**
  String get pixQrCodeHint;

  /// No description provided for @pixQrCodeError.
  ///
  /// In pt_BR, this message translates to:
  /// **'Não foi possível gerar o QR Code'**
  String get pixQrCodeError;

  /// No description provided for @productAlreadyScanned.
  ///
  /// In pt_BR, this message translates to:
  /// **'Este produto já foi escaneado nesta sessão'**
  String get productAlreadyScanned;
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
