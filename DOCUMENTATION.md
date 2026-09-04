# 🛒 Supermarket Tracker — Frontend Documentation

> **Para agentes de IA**: Esta documentação mapeia o frontend Flutter inteiro com caminhos de arquivo,
> arquitetura, rotas e funcionalidades. Consulte-a antes de explorar o código para economizar tokens.

---

## 1. Visão Geral

| Item | Detalhe |
|------|---------|
| **Framework** | Flutter 3.12.2+ (Dart) |
| **Plataforma** | Android (principal), iOS (configurado) |
| **Gerenciamento de Estado** | Riverpod 3.0.3 |
| **Roteamento** | GoRouter 17.0.1 |
| **DI** | GetIt 9.0.5 |
| **HTTP Client** | Dio 5.10.0 |
| **Storage Seguro** | flutter_secure_storage |
| **NFC** | nfc_manager 4.0.0 |
| **Scanner** | mobile_scanner 7.0.0, camera 0.11.0+2 |
| **WebSocket** | web_socket_channel 3.0.2 |
| **i18n** | flutter_localizations (PT-BR, EN) |

---

## 2. Estrutura de Diretórios

```
lib/
├── main.dart                           ← Entry point do app
├── app/
│   ├── app.dart                        ← Widget raiz (MaterialApp.router)
│   ├── config/
│   │   └── bootstrap.dart              ← Configuração inicial (DI, env, session)
│   ├── di/
│   │   └── injection.dart              ← Injeção de dependência (GetIt + Riverpod)
│   ├── l10n/                           ← Localização (PT-BR, EN)
│   │   ├── app_en.arb
│   │   ├── app_pt.arb
│   │   └── app_pt_BR.arb
│   ├── router/
│   │   └── app_router.dart             ← GoRouter central com todas as rotas
│   └── theme/
│       ├── app_theme.dart              ← Tema claro/escuro
│       └── app_theme_mode_notifier.dart ← Notifier do modo de tema
├── core/
│   ├── api/
│   │   ├── supermarket_api.dart        ← API facade (métodos públicos)
│   │   ├── datasources/
│   │   │   ├── supermarket_remote_data_source.dart   ← Data source abstrata
│   │   │   └── openapi_supermarket_data_source.dart  ← Implementação OpenAPI
│   │   ├── models/
│   │   │   ├── api_envelope.dart       ← Envelope de resposta da API
│   │   │   └── api_json.dart           ← JSON wrapper
│   │   └── repositories/
│   │       └── supermarket_api_repository.dart  ← Repository base
│   ├── cache/
│   │   └── cache_service.dart          ← Cache local
│   ├── connectivity/
│   │   └── connectivity_service.dart   ← Detecção de conexão
│   ├── environment/
│   │   └── app_environment.dart        ← Variáveis de ambiente (API_BASE_URL)
│   ├── errors/
│   │   ├── app_exception.dart          ← Exceções customizadas
│   │   ├── error_mapper.dart           ← Mapper de erros
│   │   └── global_error_handler.dart   ← Handler global
│   ├── logging/
│   │   └── app_logger.dart             ← Logger configurado
│   ├── network/
│   │   ├── api_client.dart             ← Cliente HTTP abstrato
│   │   ├── network_module.dart         ← Factory do Dio com interceptors
│   │   ├── json_parser.dart            ← Parser JSON
│   │   ├── network_request_monitor.dart← Monitor de requests
│   │   ├── interceptors/
│   │   │   ├── auth_interceptor.dart   ← JWT Bearer + refresh automático em 401
│   │   │   ├── cache_interceptor.dart  ← Cache de requests
│   │   │   ├── retry_interceptor.dart  ← Retry em falhas de rede
│   │   │   └── network_logger_interceptor.dart ← Log de requests
│   │   └── models/
│   │       └── request_metric.dart     ← Métricas de request
│   ├── nfc/
│   │   └── nfc_service.dart            ← Serviço de leitura NFC
│   ├── session/
│   │   └── session_manager.dart        ← Gerenciamento de sessão JWT
│   └── storage/
│       ├── secure_storage.dart         ← Armazenamento seguro (tokens)
│       └── storage_service.dart        ← SharedPreferences (cache leve)
├── design_system/
│   ├── design_system.dart              ← Barrel export do design system
│   ├── tokens/
│   │   ├── app_colors.dart             ← Paleta de cores
│   │   ├── app_typography.dart         ← Tipografia
│   │   ├── app_layout.dart             ← Espaçamento/layout
│   │   ├── app_icons.dart              ← Ícones customizados
│   │   └── app_effects.dart            ← Efeitos visuais
│   └── components/
│       ├── buttons.dart                ← Botões reutilizáveis
│       ├── inputs.dart                 ← Campos de entrada
│       ├── display.dart                ← Cards, tiles, displays
│       ├── feedback.dart               ← Snackbars, alerts, loading
│       └── states.dart                 ← Empty state, error state
└── features/
    ├── _shared/                        ← Código compartilhado entre features
    │   ├── data/                       ← Datasources, models, repositories compartilhados
    │   ├── domain/                     ← Entities, repositories, usecases compartilhados
    │   └── presentation/
    │       ├── constants.dart          ← Constantes globais
    │       ├── providers/
    │       │   ├── company_provider.dart     ← Provider da empresa selecionada
    │       │   └── repository_providers.dart ← Providers de repositórios
    │       └── widgets/
    │           └── async_screen.dart    ← Screen wrapper com loading/error
    ├── app_shell/                      ← Shell do app (nav + scaffold)
    │   └── presentation/
    │       ├── nav/
    │       │   └── nav_destinations.dart  ← Destinos da nav bar
    │       └── widgets/
    │           ├── app_shell_scaffold.dart  ← Scaffold com bottom nav + drawer
    │           └── coming_soon_screen.dart  ← Tela "em breve"
    ├── auth/                           ← Autenticação
    │   ├── data/
    │   │   ├── datasources/
    │   │   │   ├── auth_remote_data_source.dart
    │   │   │   └── openapi_auth_remote_data_source.dart
    │   │   ├── mappers/auth_mapper.dart
    │   │   └── repositories/auth_repository_impl.dart
    │   ├── domain/
    │   │   ├── entities/credentials.dart
    │   │   └── repositories/auth_repository.dart
    │   └── presentation/
    │       ├── providers/auth_providers.dart
    │       └── screens/
    │           ├── login_screen.dart
    │           ├── signup_screen.dart
    │           ├── forgot_password_screen.dart
    │           └── reset_password_screen.dart
    ├── company/                        ← Empresas
    │   ├── data/ → datasources/, mappers/, repositories/
    │   ├── domain/ → entities/, repositories/
    │   └── presentation/screens/
    │       ├── company_list_screen.dart
    │       └── company_create_screen.dart
    ├── store/                          ← Lojas
    │   ├── data/ → datasources/, mappers/, repositories/
    │   ├── domain/ → entities/, repositories/
    │   └── presentation/screens/
    │       ├── store_list_screen.dart
    │       ├── store_create_screen.dart
    │       └── store_detail_screen.dart
    ├── product/                        ← Produtos
    │   ├── data/ → datasources/, mappers/, repositories/
    │   ├── domain/ → entities/, repositories/
    │   └── presentation/screens/
    │       ├── product_list_screen.dart
    │       ├── product_create_screen.dart
    │       ├── product_detail_screen.dart
    │       ├── barcode_scanner_screen.dart
    │       └── product_photo_capture_screen.dart
    ├── customer/                       ← Clientes
    │   ├── data/ → datasources/, mappers/, repositories/
    │   ├── domain/ → entities/, repositories/
    │   └── presentation/screens/
    │       ├── customer_list_screen.dart
    │       ├── customer_create_screen.dart
    │       └── customer_detail_screen.dart
    ├── user/                           ← Usuários
    │   ├── data/ → datasources/, mappers/, repositories/
    │   ├── domain/ → entities/, repositories/
    │   └── presentation/screens/
    │       ├── user_list_screen.dart
    │       ├── user_create_screen.dart
    │       └── user_detail_screen.dart
    ├── cash_register/                  ← Caixas + Contas Bancárias
    │   ├── data/ → datasources/, mappers/, repositories/
    │   ├── domain/ → entities/, repositories/
    │   └── presentation/
    │       ├── providers/
    │       │   ├── cash_register_providers.dart
    │       │   └── bank_account_provider.dart
    │       └── screens/
    │           ├── cash_register_list_screen.dart
    │           ├── cash_register_create_screen.dart
    │           ├── cash_register_detail_screen.dart
    │           ├── bank_account_list_screen.dart
    │           └── bank_account_form_screen.dart
    ├── sale/                           ← Vendas + Pagamentos
    │   ├── data/ → datasources/, mappers/, repositories/
    │   ├── domain/ → entities/, repositories/
    │   └── presentation/screens/
    │       ├── sale_list_screen.dart
    │       ├── sale_scan_screen.dart          ← Scanner de produtos na venda
    │       ├── sale_summary_screen.dart       ← Resumo da venda
    │       ├── sale_pix_screen.dart           ← QR Code PIX
    │       ├── payment_method_screen.dart     ← Seleção método pagamento
    │       ├── payment_pix_screen.dart        ← Pagamento PIX
    │       ├── payment_card_screen.dart       ← Pagamento cartão (NFC)
    │       ├── payment_cash_screen.dart       ← Pagamento dinheiro
    │       └── sale_confirmation_screen.dart  ← Confirmação da venda
    ├── stock_movement/                 ← Movimentações de Estoque
    │   ├── data/ → datasources/, mappers/, repositories/
    │   ├── domain/ → entities/, repositories/
    │   └── presentation/screens/
    │       ├── stock_movement_list_screen.dart
    │       └── stock_movement_create_screen.dart
    └── dashboard/                      ← Dashboard
        ├── data/ → datasources/, mappers/, repositories/
        ├── domain/ → entities/, repositories/
        └── presentation/screens/
            └── dashboard_screen.dart
```

---

## 3. Arquitetura

**Padrão**: Clean Architecture com feature-based organization.

```
┌─────────────────────────────────────────────────────────┐
│  PRESENTATION (UI)                                      │
│  Screens → Providers (Riverpod) → ViewModels (state)   │
├─────────────────────────────────────────────────────────┤
│  DOMAIN                                                 │
│  Entities → Repository interfaces → Use Cases           │
├─────────────────────────────────────────────────────────┤
│  DATA                                                   │
│  Repository Impl → DataSources → API (Dio)              │
│                          ↓                              │
│                    Mappers (API ↔ Entity)                │
├─────────────────────────────────────────────────────────┤
│  CORE                                                   │
│  Network (Dio + Interceptors)                           │
│  SessionManager (JWT)                                   │
│  Storage (Secure + SharedPreferences)                   │
│  Environment (Config)                                   │
│  Cache + Connectivity                                   │
└─────────────────────────────────────────────────────────┘
```

**Fluxo de dados típico**:
```
Screen (Flutter Widget)
  → Provider (Riverpod) dispara ação
    → UseCase ou Repository diretamente
      → RemoteDataSource (via Dio)
        → Backend API
      → Mapper (JSON → Entity)
    → Estado atualizado via StateNotifier/AsyncValue
  → Screen reconstrói com novo estado
```

---

## 4. Rotas (GoRouter)

Todas as rotas estão em `app/lib/app/router/app_router.dart`.

### Rotas Públicas (sem autenticação)

| Rota | Tela | Descrição |
|------|------|-----------|
| `/login` | `LoginScreen` | Tela de login |
| `/signup` | `SignupScreen` | Cadastro de novo usuário |
| `/forgot-password` | `ForgotPasswordScreen` | Solicitação de reset |
| `/reset-password` | `ResetPasswordScreen` | Redefinição de senha |

### Rotas Autenticadas (dentro do ShellRoute com nav bar)

| Rota | Tela | Descrição |
|------|------|-----------|
| `/dashboard` | `DashboardScreen` | Dashboard principal |
| `/stores` | `StoreListScreen` | Lista de lojas |
| `/stores/new` | `StoreCreateScreen` | Criar loja |
| `/stores/:id` | `StoreDetailScreen` | Detalhe da loja |
| `/products` | `ProductListScreen` | Lista de produtos |
| `/products/new` | `ProductCreateScreen` | Criar produto |
| `/products/new/scan-barcode` | `BarcodeScannerScreen` | Scanner de código de barras |
| `/products/new/photo` | `ProductPhotoCaptureScreen` | Captura de foto do produto |
| `/products/:id` | `ProductDetailScreen` | Detalhe do produto |
| `/products/:id/edit` | `ProductCreateScreen` (editing) | Editar produto |
| `/sales` | `SaleListScreen` | Lista de vendas |
| `/sales/scan` | `SaleScanScreen` | Scanner de itens na venda |
| `/sales/summary` | `SaleSummaryScreen` | Resumo da venda |
| `/sales/summary/payment-method` | `PaymentMethodScreen` | Selecionar método pagamento |
| `/sales/summary/payment-pix` | `PaymentPixScreen` | Pagamento PIX |
| `/sales/summary/payment-card` | `PaymentCardScreen` | Pagamento cartão |
| `/sales/summary/payment-cash` | `PaymentCashScreen` | Pagamento dinheiro |
| `/sales/pix` | `SalePixScreen` | QR Code PIX (passa sale via extra) |
| `/sales/confirmation` | `SaleConfirmationScreen` | Confirmação da venda |
| `/stock` | `StockMovementListScreen` | Movimentações de estoque |
| `/cash` | `CashRegisterListScreen` | Lista de caixas |
| `/cash/new` | `CashRegisterCreateScreen` | Criar caixa |
| `/cash/:id` | `CashRegisterDetailScreen` | Detalhe do caixa |
| `/cash/:id/link-bank` | `BankAccountFormScreen` | Vincular conta bancária |
| `/cash/bank-accounts` | `BankAccountListScreen` | Lista de contas bancárias |
| `/cash/bank-accounts/new` | `BankAccountFormScreen` | Criar conta bancária |
| `/cash/bank-accounts/:id/edit` | `BankAccountFormScreen` (editing) | Editar conta bancária |
| `/customers` | `CustomerListScreen` | Lista de clientes |
| `/customers/new` | `CustomerCreateScreen` | Criar cliente |
| `/customers/:id` | `CustomerDetailScreen` | Detalhe do cliente |
| `/users` | `UserListScreen` | Lista de usuários |
| `/users/new` | `UserCreateScreen` | Criar usuário |
| `/users/:id` | `UserDetailScreen` | Detalhe do usuário |
| `/company` | `CompanyListScreen` | Lista de empresas |
| `/company/new` | `CompanyCreateScreen` | Criar empresa |

### Lógica de Redirecionamento

```
Sem sessão    → /login
Com sessão    → /dashboard
Com sessão, sem empresa  → /company/new
Com sessão, empresa ok, sem loja  → /stores
```

---

## 5. SessionManager (Autenticação)

**Arquivo**: `app/lib/core/session/session_manager.dart`

- **Tokens**: Access token (15min) + Refresh token (7d)
- **Persistência**: flutter_secure_storage (chaves criptografadas)
- **Provider**: `sessionManagerProvider` (Riverpod)
- **State**: `ValueNotifier<bool> isAuthenticated` — o GoRouter escuta para redirecionar

**Fluxo de Refresh**:
1. `AuthInterceptor` detecta 401/403
2. Chama `POST /api/v1/auth/refresh` com o refresh token
3. Atualiza o access token via `sessionManager.updateAccessToken()`
4. Reenvia a request original
5. Se falhar → `sessionManager.clear()` → redirect para `/login`

---

## 6. Network Layer

**Arquivo principal**: `app/lib/core/network/network_module.dart`

### Interceptors (ordem de execução)
1. **AuthInterceptor** — Anexa `Authorization: Bearer <token>` e renova em 401
2. **RetryInterceptor** — Retry automático quando offline/timeout
3. **CacheInterceptor** — Cache de responses GET
4. **NetworkLoggerInterceptor** — Log de requests/responses

### Configuração Dio
```dart
BaseOptions(
  baseUrl: environment.apiBaseUrl,    // Ex: http://192.168.1.2:8080
  connectTimeout: Duration(seconds: 15),
  sendTimeout: Duration(seconds: 15),
  receiveTimeout: Duration(seconds: 30),
  responseType: ResponseType.json,
  headers: {'Accept': 'application/json'},
)
```

---

## 7. Environment (Config)

**Arquivo**: `app/lib/core/environment/app_environment.dart`

### Arquivos de Config por Ambiente

| Ambiente | Arquivo | API Base URL |
|----------|---------|--------------|
| **dev** | `assets/config/.env.dev` | `http://192.168.1.2:8080` |
| **homolog** | `assets/config/.env.homolog` | `https://homolog-api.supermarkettracker.com.br` |
| **prod** | `assets/config/.env.prod` | `https://api.supermarkettracker.com.br` (ou similar) |

### Variáveis por .env
```
APP_NAME=Supermarket Tracker Dev
ENABLE_LOGS=true
API_BASE_URL=http://192.168.1.2:8080
```

---

## 8. Design System

**Diretório**: `app/lib/design_system/`

### Tokens (Design Tokens)
| Arquivo | Descrição |
|---------|-----------|
| `tokens/app_colors.dart` | Paleta de cores do app |
| `tokens/app_typography.dart` | Estilos de texto |
| `tokens/app_layout.dart` | Espaçamentos, border radius, tamanhos |
| `tokens/app_icons.dart` | Ícones customizados |
| `tokens/app_effects.dart` | Sombras, gradientes, efeitos |

### Componentes Reutilizáveis
| Arquivo | Descrição |
|---------|-----------|
| `components/buttons.dart` | Botões (primário, secundário, etc.) |
| `components/inputs.dart` | Campos de texto, dropdowns |
| `components/display.dart` | Cards, tiles de dados |
| `components/feedback.dart` | Snackbars, alerts, loading indicators |
| `components/states.dart` | Empty states, error states |

---

## 9. Features Detalhadas

### Auth (`features/auth/`)
- **Login**: Email + senha → JWT tokens
- **Signup**: Cadastro de novo usuário
- **Forgot Password**: Solicita reset por email
- **Reset Password**: Redefine com token recebido

### Company (`features/company/`)
- Gerenciar empresas (CRUD)
- Seleção de empresa ativa

### Store (`features/store/`)
- Gerenciar lojas da empresa (CRUD)
- Seleção de loja ativa

### Product (`features/product/`)
- CRUD de produtos com categorias
- Scanner de código de barras (mobile_scanner)
- Captura de foto do produto (camera)

### Customer (`features/customer/`)
- CRUD de clientes

### User (`features/user/`)
- CRUD de usuários da empresa

### Cash Register (`features/cash_register/`)
- Gerenciar caixas (CRUD)
- Gerenciar sessões de caixa (abrir/fechar)
- Gerenciar contas bancárias vinculadas

### Sale (`features/sale/`)
- **Fluxo completo de venda**:
  1. Escanear itens (barcode scanner)
  2. Ver resumo da venda
  3. Selecionar método de pagamento
  4. Processar pagamento (PIX / Cartão NFC / Dinheiro)
  5. Confirmar venda
- WebSocket para status de pagamento em tempo real

### Stock Movement (`features/stock_movement/`)
- Registrar entrada/saída de estoque
- Listar movimentações

### Dashboard (`features/dashboard/`)
- Resumo de vendas do dia
- Produtos mais vendidos
- Última venda realizada
- Produtos com estoque baixo

---

## 10. Guia para Agentes de IA

### Onde encontrar o que

| Quer fazer... | Olhar em... |
|---------------|-------------|
| Criar nova tela | Criar em `features/<feature>/presentation/screens/`, adicionar rota em `app/router/app_router.dart` |
| Criar novo provider | Criar em `features/<feature>/presentation/providers/` |
| Criar novo repositório | Interface em `domain/repositories/`, impl em `data/repositories/` |
| Criar novo data source | Interface em `data/datasources/`, impl em `data/datasources/openapi_*.dart` |
| Criar novo mapper | `data/mappers/<feature>_mapper.dart` |
| Criar novo componente | `design_system/components/` |
| Alterar tema | `app/theme/app_theme.dart` |
| Alterar rotas | `app/router/app_router.dart` |
| Alterar interceptors de rede | `core/network/interceptors/` |
| Alterar sessão/auth | `core/session/session_manager.dart` |
| Alterar ambiente | `assets/config/.env.<ambiente>` |

### Padrões de código

- **Clean Architecture**: Cada feature tem `data/`, `domain/`, `presentation/`
- **Riverpod Providers**: Estado gerenciado via `StateNotifier` ou `AsyncValue`
- **Mapper pattern**: Conversão entre API models ↔ Domain entities
- **DataSource pattern**: Abstração da API (implementações OpenAPI)
- **AsyncScreen**: Wrapper que lida com loading/error/empty states

### Dependências principais

```yaml
flutter_riverpod: Gerenciamento de estado
go_router: Roteamento declarativo
dio: HTTP client
flutter_secure_storage: Armazenamento seguro (tokens)
shared_preferences: Cache leve
nfc_manager: Leitura de cartões NFC
mobile_scanner: Scanner de código de barras
camera: Câmera para fotos
web_socket_channel: WebSocket para tempo real
get_it: Injeção de dependência
```

### Build e Run

```bash
# Instalar dependências
flutter pub get

# Rodar em device/emulador
flutter run --dart-define=APP_ENV=dev

# Build Android (release)
flutter build apk --release --dart-define=APP_ENV=prod

# Build Android (debug)
flutter build apk --debug --dart-define=APP_ENV=dev

# Testes
flutter test

# Análise de código
flutter analyze
```

---

*Documento gerado automaticamente. Última atualização: 2026-09-03.*
