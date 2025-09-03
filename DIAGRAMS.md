# Mermaid Diagram Examples

## State Diagram - User Authentication
```mermaid
stateDiagram-v2
    [*] --> LoggedOut
    LoggedOut --> Authenticating : login attempt
    Authenticating --> LoggedIn : success
    Authenticating --> LoggedOut : failure
    LoggedIn --> LoggedOut : logout
    LoggedIn --> SessionExpired : timeout
    SessionExpired --> LoggedOut : acknowledge

    state Authenticating {
        [*] --> ValidatingCredentials
        ValidatingCredentials --> CheckingMFA : valid creds
        CheckingMFA --> [*] : MFA success
        ValidatingCredentials --> [*] : invalid creds
    }
```

## Class Diagram - E-commerce System
```mermaid
classDiagram
    class User {
        +String email
        +String password
        +login()
        +logout()
        +updateProfile()
    }

    class Order {
        +String orderId
        +Date orderDate
        +OrderStatus status
        +calculateTotal()
        +addItem()
        +removeItem()
    }

    class Product {
        +String productId
        +String name
        +Float price
        +Integer stock
        +updateStock()
        +getDetails()
    }

    class OrderItem {
        +Integer quantity
        +Float unitPrice
        +getSubtotal()
    }

```

So this

    User ||--o{ Order : places
    Order ||--o{ OrderItem : contains
    Product ||--o{ OrderItem : references

does not work

## Flowchart - Code Review Process
```mermaid
flowchart TD
    A[Create Pull Request] --> B{Code Review Required?}
    B -->|Yes| C[Assign Reviewers]
    B -->|No| D[Auto-merge]
    C --> E[Review Code]
    E --> F{Approved?}
    F -->|Yes| G{Tests Pass?}
    F -->|No| H[Request Changes]
    G -->|Yes| I[Merge to Main]
    G -->|No| J[Fix Tests]
    H --> K[Make Changes]
    K --> E
    J --> G
    I --> L[Deploy]
    D --> L
```

## Sequence Diagram - API Authentication
```mermaid
sequenceDiagram
    participant C as Client
    participant A as Auth Service
    participant R as Resource Server
    participant D as Database

    C->>A: POST /login {username, password}
    A->>D: Validate credentials
    D-->>A: User found
    A->>A: Generate JWT token
    A-->>C: Return {token, expires}

    Note over C: Store token locally

    C->>R: GET /protected-resource
    Note over C,R: Authorization: Bearer token

    R->>A: Validate token
    A-->>R: Token valid
    R->>D: Fetch user data
    D-->>R: User data
    R-->>C: Protected resource data
```

## Entity Relationship Diagram - Blog System
```mermaid
erDiagram
    USER {
        int user_id PK
        string username
        string email
        datetime created_at
    }

    POST {
        int post_id PK
        int author_id FK
        string title
        text content
        datetime published_at
        boolean is_published
    }

    COMMENT {
        int comment_id PK
        int post_id FK
        int user_id FK
        text content
        datetime created_at
    }

    TAG {
        int tag_id PK
        string name
        string slug
    }

    POST_TAG {
        int post_id FK
        int tag_id FK
    }

    USER ||--o{ POST : writes
    USER ||--o{ COMMENT : makes
    POST ||--o{ COMMENT : has
    POST }o--o{ TAG : tagged_with
```

## Gantt Chart - Project Timeline (Fixed Overlapping)
```mermaid
%%{init: {
  'theme': 'base',
  'themeVariables': {
    'primaryColor': '#ff6b6b',
    'primaryTextColor': '#333',
    'primaryBorderColor': '#ff6b6b',
    'lineColor': '#333',
    'axisTextColor': '#333'
  },
  'gantt': {
    'leftPadding': 100,
    'gridLineStartPadding': 350,
    'fontSize': 12,
    'sectionFontSize': 14
  }
}}%%
gantt
    title Software Development Project
    dateFormat  YYYY-MM-DD
    axisFormat  %m/%d

    section Planning
    Requirements Analysis    :done, req, 2024-01-01, 2024-01-15
    System Design          :done, design, 2024-01-10, 2024-01-25

    section Development
    Backend Development     :active, backend, 2024-01-20, 2024-03-15
    Frontend Development    :frontend, 2024-02-01, 2024-03-20
    Database Setup         :done, db, 2024-01-25, 2024-02-10

    section Testing
    Unit Testing           :testing, 2024-02-15, 2024-03-30
    Integration Testing    :int-test, 2024-03-15, 2024-04-05
    User Acceptance Testing :uat, 2024-03-25, 2024-04-10

    section Deployment
    Production Setup       :prod-setup, 2024-04-01, 2024-04-15
    Go Live               :milestone, 2024-04-15, 0d
```

## Alternative Gantt Chart - Weekly Format
```mermaid
gantt
    title Software Development Project (Weekly View)
    dateFormat  YYYY-MM-DD
    axisFormat  %b %d

    section Phase 1
    Planning & Design       :done, phase1, 2024-01-01, 3w

    section Phase 2
    Backend Development     :active, phase2, 2024-01-22, 7w
    Frontend Development    :phase2b, 2024-02-05, 6w

    section Phase 3
    Testing & QA           :phase3, 2024-03-11, 4w

    section Phase 4
    Deployment             :phase4, 2024-04-08, 1w
```

## Git Graph - Feature Branch Flow
```mermaid
gitGraph
    commit id: "Initial commit"
    commit id: "Add user model"
    branch feature/auth
    checkout feature/auth
    commit id: "Add login endpoint"
    commit id: "Add JWT middleware"
    checkout main
    commit id: "Fix database config"
    merge feature/auth
    commit id: "Update README"
    branch feature/orders
    checkout feature/orders
    commit id: "Add order model"
    commit id: "Add order endpoints"
    checkout main
    merge feature/orders
    commit id: "Release v1.0"
```

## User Journey - Online Shopping
```mermaid
journey
    title Online Shopping Experience
    section Discovery
      Visit homepage        : 5: Customer
      Browse categories     : 4: Customer
      Search products       : 4: Customer

    section Selection
      View product details  : 3: Customer
      Read reviews         : 4: Customer
      Add to cart          : 5: Customer

    section Checkout
      Review cart          : 4: Customer
      Enter shipping info  : 2: Customer
      Select payment       : 3: Customer
      Complete purchase    : 5: Customer

    section Post-Purchase
      Receive confirmation : 5: Customer
      Track shipment       : 4: Customer
      Receive product      : 5: Customer
```

```mermaid
    C4Context
      title System Context diagram for Internet Banking System
      Enterprise_Boundary(b0, "BankBoundary0") {
        Person(customerA, "Banking Customer A", "A customer of the bank, with personal bank accounts.")
        Person(customerB, "Banking Customer B")
        Person_Ext(customerC, "Banking Customer C", "desc")

        Person(customerD, "Banking Customer D", "A customer of the bank, <br/> with personal bank accounts.")

        System(SystemAA, "Internet Banking System", "Allows customers to view information about their bank accounts, and make payments.")

        Enterprise_Boundary(b1, "BankBoundary") {

          SystemDb_Ext(SystemE, "Mainframe Banking System", "Stores all of the core banking information about customers, accounts, transactions, etc.")

          System_Boundary(b2, "BankBoundary2") {
            System(SystemA, "Banking System A")
            System(SystemB, "Banking System B", "A system of the bank, with personal bank accounts. next line.")
          }

          System_Ext(SystemC, "E-mail system", "The internal Microsoft Exchange e-mail system.")
          SystemDb(SystemD, "Banking System D Database", "A system of the bank, with personal bank accounts.")

          Boundary(b3, "BankBoundary3", "boundary") {
            SystemQueue(SystemF, "Banking System F Queue", "A system of the bank.")
            SystemQueue_Ext(SystemG, "Banking System G Queue", "A system of the bank, with personal bank accounts.")
          }
        }
      }

      BiRel(customerA, SystemAA, "Uses")
      BiRel(SystemAA, SystemE, "Uses")
      Rel(SystemAA, SystemC, "Sends e-mails", "SMTP")
      Rel(SystemC, customerA, "Sends e-mails to")

      UpdateElementStyle(customerA, $fontColor="red", $bgColor="grey", $borderColor="red")
      UpdateRelStyle(customerA, SystemAA, $textColor="blue", $lineColor="blue", $offsetX="5")
      UpdateRelStyle(SystemAA, SystemE, $textColor="blue", $lineColor="blue", $offsetY="-10")
      UpdateRelStyle(SystemAA, SystemC, $textColor="blue", $lineColor="blue", $offsetY="-40", $offsetX="-50")
      UpdateRelStyle(SystemC, customerA, $textColor="red", $lineColor="red", $offsetX="-50", $offsetY="20")

      UpdateLayoutConfig($c4ShapeInRow="3", $c4BoundaryInRow="1")
```