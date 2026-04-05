# Project-Type Presets

## Purpose

Type-specific configuration that adapts framework behavior to the kind of software being built. Set during `/init` via `.antigravity/config.yaml → project_type`.

---

## Wave Presets

Waves define the implementation order. Each project type has a tailored wave structure:

| Wave | web-app | cli-tool | library | api-service | ml-pipeline | mobile-app |
|------|---------|----------|---------|-------------|-------------|------------|
| 0-1 | Types & Utilities | Config & Types | Types & Core | Config & Types | Data Prep & Types | Types & Utilities |
| 2 | Data Layer | Core Logic | Utils & Helpers | Data Layer | Training | Data Layer |
| 3 | Services | Commands | Public API | Services | Evaluation | Services |
| 4 | API Layer | Output & Formatting | Tests & Docs | API Layer | Serving | API/IPC Bridge |
| 5 | UI Components | Tests & Packaging | Packaging | Tests & Deploy | Monitoring | Native UI |
| 6 | Integration | Shell Integration | — | — | — | Integration |

- **custom**: Waves defined during planning. User specifies order in `planning-handoff.md`.
- Waves marked `—` are skipped for that project type.

---

## Feature Categories

Used during Planning Phase 1 (Discovery) for thoroughness checking. Categories vary by project type.

### Universal Categories (All Types)
1. Error Handling & Recovery
2. Performance & Optimization
3. Security & Access Control
4. Documentation
5. Import/Export & Data Portability
6. Integration Points

### Web-App Categories
7. Authentication
8. Authorization & RBAC
9. User Management
10. Notifications
11. Settings & Preferences
12. Accessibility (WCAG)
13. Search & Filtering
14. CRUD Operations
15. Reporting & Analytics
16. Logging & Monitoring

### CLI-Tool Categories
7. Input Parsing & Validation
8. Output Formatting (text, JSON, table)
9. Configuration Management
10. Help System & Docs
11. Shell Integration (completions, pipes)
12. Progress Display

### Library Categories
7. Public API Surface
8. Type Safety
9. Composability & Extensibility
10. Tree-Shaking / Bundle Size
11. Deprecation Strategy
12. Migration Guides

### API-Service Categories
7. Authentication & API Keys
8. Rate Limiting
9. Request Validation
10. Response Formatting
11. Versioning
12. Health Checks & Observability

### ML-Pipeline Categories
7. Data Validation & Cleaning
8. Feature Engineering
9. Model Training & Evaluation
10. Model Serving & Inference
11. Monitoring & Drift Detection
12. Reproducibility

### Mobile-App Categories
7. Authentication
8. Offline Support
9. Push Notifications
10. Device Permissions
11. Accessibility
12. Deep Linking

---

## Verification Layers

Used during Validation Council for runtime verification. Replace the default 8-layer web-app model.

### web-app (8 layers)
1. UI Interaction → 2. Event Handler → 3. Frontend Logic → 4. API/IPC Bridge → 5. Backend Handler → 6. Service Logic → 7. Persistence → 8. Load on Restart

### cli-tool (5 layers)
1. Input (args, stdin, config) → 2. Logic (processing) → 3. Output (stdout, files) → 4. Error (stderr, exit codes) → 5. Edge Cases (empty input, large files, interrupts)

### library (5 layers)
1. Public API (exported functions) → 2. Internal Logic → 3. Type Safety (generics, overloads) → 4. Error Handling (thrown vs returned) → 5. Documentation (JSDoc, docstrings)

### api-service (7 layers)
1. Request (parsing, validation) → 2. Auth (tokens, API keys) → 3. Logic (service, business rules) → 4. Response (formatting, status codes) → 5. Error (error responses, logging) → 6. Persistence (database, cache) → 7. Restart Recovery (state, connections)

### ml-pipeline (6 layers)
1. Data Input (loading, schema) → 2. Preprocessing (transforms, features) → 3. Model (training, inference) → 4. Output (predictions, metrics) → 5. Monitoring (drift, performance) → 6. Reproducibility (seeds, versioning)

### mobile-app (8 layers)
Same as web-app, adapted for mobile: 1. UI Interaction → 2. Event Handler → 3. Component Logic → 4. API/IPC Bridge → 5. Backend Handler → 6. Service Logic → 7. Persistence → 8. Cold Start Recovery

---

## Evidence Formats

Used during Audit and Validation Councils for defect evidence and correction proof.

| project_type | Defect Evidence | Correction Proof |
|-------------|----------------|-----------------|
| `web-app` | Screenshots | Before/after screenshots + test |
| `cli-tool` | Terminal output | Before/after terminal diffs + test |
| `library` | Test output | Failing→passing tests + API diff |
| `api-service` | Request/response logs | Before/after request/response diffs + test |
| `ml-pipeline` | Metric logs | Before/after metric comparisons + test |
| `mobile-app` | Screenshots | Before/after screenshots + test |

---

## How Workflows Use Presets

1. Read `.antigravity/config.yaml → project_type`
2. Look up the relevant section in this file
3. Apply type-specific configuration:
   - **Planning**: Use Feature Categories for thoroughness checking
   - **Development**: Use Wave Presets for wave naming and ordering
   - **Audit**: Use Evidence Formats for defect documentation
   - **Validation**: Use Verification Layers and Evidence Formats
