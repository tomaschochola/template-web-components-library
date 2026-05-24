# Native Web Components Development Doctrine

Frozen final source-code doctrine for native autonomous Web Components in this repository.

## 1. Authority and scope

This doctrine defines the canonical way to write native autonomous Web Components source code in this repository.

It governs:

1. Component admission.
2. Naming.
3. Module shape.
4. Registration source code.
5. Public API.
6. Attributes and properties.
7. State ownership.
8. Shadow DOM ownership.
9. Static templates.
10. SCSS source imports.
11. Constructable stylesheets.
12. DOM refs.
13. Rendering.
14. Events.
15. Slots.
16. Forms.
17. Accessibility.
18. Focus.
19. Security sinks.
20. Resource ownership.
21. Async staleness.
22. Performance.
23. Review rejection.

It does not govern project setup, bundler configuration, test-runner setup, CI, package publishing, release engineering, root HTML, routing, app state management, application services, app shell architecture, or visual design systems.

The component model is:

1. Autonomous custom elements only.
2. Direct `HTMLElement` subclassing only.
3. Open Shadow DOM for component-owned DOM and styles.
4. Static no-interpolation templates.
5. SCSS imported as CSS text through `.scss?source`.
6. Constructable stylesheets with per-document caching.
7. Direct DOM patching.
8. Explicit registration.
9. Explicit public API.
10. Local private state.
11. Boundary validation only where a real boundary exists.

Repository assumptions:

1. Closed-source internal codebase.
2. Expert-only developers.
3. Latest stable 2026+ browsers only.
4. TypeScript-authored source.
5. Strict erasable TypeScript syntax discipline.
6. ES modules.
7. Webpack-built application.
8. No third-party runtime libraries inside components.
9. No framework runtime inside components.
10. No SSR requirement.
11. No unknown external consumer requirement.
12. Component SCSS is authored as SCSS and imported by component source as CSS text through `.scss?source`.
13. Component styles are applied with constructable stylesheets.
14. Static typing, review discipline, repository conventions, and this doctrine are the primary guardrails for trusted internal code.

Community convention is not authority. Framework culture is not authority. Enterprise convention is not authority. Package popularity is not authority. Existing repository convention is evidence, not law, when it is technically weaker than this doctrine.

Source decisions are evaluated by:

1. Correctness.
2. Security.
3. Accessibility.
4. Determinism.
5. Strong invariants.
6. Type safety.
7. Explicit data flow.
8. Explicit control flow.
9. Bounded resources.
10. Performance by construction.
11. Reviewability.
12. Minimal trusted surface.
13. Modern platform semantics.
14. Simplicity without hidden behavior.

Custom elements are browser-constructed classes registered with `CustomElementRegistry.define()`. Autonomous custom elements extend `HTMLElement`.

## 2. Core mental model

A Web Component is a browser-owned object with identity, lifecycle, private state, owned DOM, owned styles, explicit public API, and bounded resources.

A component is not:

1. A framework instance.
2. A router.
3. A store.
4. A service locator.
5. A dependency-injection participant.
6. A template engine.
7. A defensive shell around trusted TypeScript misuse.
8. A sink for raw hostile data.
9. A place for hidden global I/O.
10. A compatibility layer for weak ecosystem habits.

A component owns:

1. Its host behavior.
2. Its shadow root.
3. Its internal DOM.
4. Its internal styles.
5. Its internal event listeners.
6. Its private state.
7. Its connection-scoped resources.
8. Its public DOM contract.

A component does not own:

1. Application routing.
2. Application stores.
3. Network policy.
4. Storage policy.
5. Global application services.
6. Consumer-owned slotted DOM.
7. Application registration order beyond its exported define function.

The public DOM contract consists only of:

1. Tag name.
2. Public attributes.
3. Public properties.
4. Public methods.
5. Public events.
6. Slots.
7. Parts.
8. Public CSS custom properties.
9. Documented custom states.
10. Form behavior.
11. Accessibility behavior.
12. Focus behavior.

Everything else is implementation detail.

## 2.1 Public contract drift

Public component contract surfaces MUST NOT drift accidentally.

Public contract surfaces include:

1. Tag names.
2. Public attributes.
3. Public properties.
4. Public methods.
5. Public event names.
6. Public event detail shapes.
7. Slots.
8. Parts.
9. Public CSS custom properties.
10. Documented custom states.
11. Form submission behavior.
12. Form reset and restore behavior.
13. Accessibility role/name/value/state behavior.
14. Focus behavior.

Rules:

1. A public contract change MUST be deliberate.
2. Internal closed-source implementation details MAY change when the change improves correctness, security, accessibility, determinism, performance, simplicity, or maintainability.
3. Public contract changes MUST update all known internal callsites.
4. Renaming a public event, attribute, slot, part, CSS custom property, or custom state is a contract change.
5. Changing public event detail shape is a contract change.
6. Changing submitted form entry names is a contract change.
7. Changing host-owned versus internal-native-control accessibility ownership is a contract change.
8. Changing focus behavior is a contract change.
9. Internal classes, internal IDs, `data-ref`, DOM depth, and anonymous wrappers are not public contract.

## 3. Component admission

Create a Web Component only when at least one condition is true:

1. The unit needs browser-managed identity and lifecycle.
2. The unit owns reusable DOM and style.
3. The unit must be usable directly in HTML.
4. The unit participates in focus, forms, accessibility, slots, or platform events as an element.
5. The unit owns resources tied to connection and disconnection.
6. The unit exposes a stable DOM contract.

Do not create a Web Component for:

1. Pure formatting.
2. Pure data transformation.
3. Domain services.
4. Network adapters.
5. Storage adapters.
6. Routing logic.
7. Application stores.
8. One-off layout with no stable element contract.

## 4. Non-negotiable architecture

MUST:

1. Use autonomous custom elements.
2. Extend `HTMLElement` directly.
3. Use explicit registration.
4. Use open Shadow DOM for component-owned DOM and styles.
5. Use static templates without runtime interpolation.
6. Import component SCSS as CSS text through `.scss?source`.
7. Apply component styles with constructable stylesheets.
8. Patch DOM directly.
9. Use ECMAScript private fields and methods.
10. Validate hostile, serialized, DOM, URL, HTML, CSS, script, storage, network, slotted-behavior, forged-event, and platform-erased boundaries.

MUST NOT:

1. Use customized built-in elements.
2. Use a base component class.
3. Use decorators.
4. Use a reactive-property runtime.
5. Use virtual DOM.
6. Use a runtime template DSL.
7. Use runtime HTML interpolation.
8. Self-register as an import side effect.
9. Auto-discover components.
10. Import third-party runtime libraries inside component modules.
11. Import app routers, stores, services, or dependency containers.
12. Add defensive runtime type checks for trusted internal TypeScript property values.
13. Add per-component browser feature probes for admitted platform features.

## 5. Trust model

The repository uses boundary-first trust.

Validate, parse, encode, or reject at the true boundary. After boundary admission, internal component hot paths consume typed values without repeated defensive checks.

### 5.1 Trusted authored component source

Definition: TypeScript and SCSS authored in this repository and reviewed under this doctrine.

Runtime validation status: unnecessary except where the platform erases types.

Rules:

1. Do not add runtime checks for impossible states created only by trusted component source.
2. Do not log warnings for doctrine violations.
3. Do not silently normalize programmer mistakes.
4. Do use fail-fast checks when static markup is converted into typed DOM refs.

### 5.2 Trusted internal TypeScript callers

Definition: internal TypeScript code compiled and reviewed under the same source discipline.

Runtime validation status: unnecessary.

Rules:

1. A `boolean` property setter MUST NOT check `typeof value === "boolean"` merely because JavaScript could call it incorrectly.
2. A property accepting a domain type assumes the caller has already validated hostile data into that domain type.
3. Do not deep-validate already-admitted domain objects in hot paths.
4. Do not clone trusted immutable data merely defensively.

### 5.3 TypeScript-enforced component APIs

Definition: public properties, methods, event detail types, and exported domain types consumed by internal TypeScript code.

Runtime validation status: forbidden for ordinary type enforcement; required if the API intentionally accepts boundary values.

Rules:

1. Prefer precise types.
2. Accept `unknown` only at explicit hostile or dynamic boundaries.
3. Convert `unknown` to a domain type before storing it.
4. Avoid broad options bags unless the domain is genuinely a set of independent options.
5. If the component retains caller-owned mutable data, clone once at the API boundary or redesign the API.

### 5.4 Serialized attribute boundary

Definition: attributes are string-or-null DOM data.

Runtime validation status: parsing required.

Rules:

1. Observed attributes MUST parse into private typed state.
2. Absent attributes map to documented defaults.
3. Present invalid constrained values fail fast.
4. Boolean attributes use HTML presence semantics.
5. Attribute parsing is not general runtime paranoia.

### 5.5 Platform-erased DOM boundaries

Definition: DOM queries, slotted nodes, external DOM references, custom event detail, form restore state, URL strings, storage strings, and serialized browser data.

Runtime validation status: required.

Rules:

1. DOM query results MUST be checked before storing typed refs.
2. Slotted DOM MUST be treated as external if behavior depends on it.
3. External `CustomEvent.detail` MUST be validated if consumed.
4. Serialized browser state MUST be parsed and validated.
5. External DOM references MUST be validated before storage or use.

### 5.6 Hostile boundaries

Definition: user input, network data, storage data, URL params, uploaded files, clipboard data, drag/drop data, `postMessage` data, untrusted serialized data, and any value from outside trusted internal authored code.

Runtime validation status: mandatory.

Rules:

1. Parse JSON to `unknown`.
2. Validate `unknown` into a domain type at the boundary.
3. Reject or fail closed on invalid hostile data.
4. Do not pass raw hostile values into component internals.
5. Do not make every component revalidate already-admitted domain values.

## 6. TypeScript source policy

Allowed:

1. Type annotations.
2. Interfaces.
3. Type aliases.
4. Generics.
5. `import type`.
6. `export type`.
7. `readonly`.
8. `as const`.
9. `satisfies`.
10. ECMAScript private fields and methods.
11. Normal JavaScript classes.
12. Normal JavaScript functions.
13. Normal ES modules.

Forbidden:

1. `enum`.
2. `const enum`.
3. `namespace`.
4. Decorators.
5. Parameter properties.
6. TypeScript `private` as runtime privacy.
7. TypeScript syntax with runtime emit.
8. Experimental metadata.
9. `as any`.
10. Broad unchecked casts.
11. Routine non-null assertions.
12. Default exports from component modules.
13. Implicit side-effect imports in component modules.

Rules:

1. Use `#private` fields and methods for private runtime state.
2. Use `import type` for type-only imports.
3. Use `satisfies` to check static records without widening them.
4. Use `undefined` for uninitialized optional internal state.
5. Use `null` where DOM APIs use `null`.
6. Do not mix `null` and `undefined` for the same state concept.
7. Use `unknown` at hostile boundaries.
8. Do not use clever type-level code that obscures runtime behavior.

TypeScript’s erasable-syntax discipline rejects TypeScript-specific runtime constructs such as parameter properties, which aligns with this source policy.

## 7. Allowed primitives

A shared primitive is allowed only if it has one narrow job and hides no lifecycle, state, rendering, registration, routing, dependency access, form behavior, event policy, attribute policy, or reactivity.

Allowed primitive categories:

1. Same-realm document view lookup.
2. Per-document constructable stylesheet creation/cache.
3. One-time typed shadow ref extraction.
4. Pure parsers for constrained serialized attributes.
5. Small abort/cleanup helpers for non-abortable browser APIs.
6. Pure value normalization functions for domain values.

Rules:

1. A primitive MUST have a single responsibility.
2. A primitive MUST NOT retain element instances.
3. A primitive MUST NOT subscribe to lifecycle implicitly.
4. A primitive MUST NOT dispatch events.
5. A primitive MUST NOT schedule renders.
6. A primitive MUST NOT reflect attributes.
7. A primitive MUST NOT attach `ElementInternals`.
8. A primitive MUST NOT read application globals.
9. A primitive MUST NOT access routers, stores, services, or dependency containers.
10. A primitive MAY retain a `WeakMap<Document, CSSStyleSheet>` for stylesheet caching.
11. Any primitive with callbacks, hidden queues, or per-element registration is presumed nonconforming until justified.

Forbidden primitive categories:

1. Base component classes.
2. Lifecycle controllers as the default pattern.
3. Render scheduler classes as the default pattern.
4. Reactive property systems.
5. Attribute reflection frameworks.
6. Event dispatch frameworks.
7. Form controllers as the default pattern.
8. Dependency injection.
9. Router/store/service bridges.
10. Component discovery.
11. Registration helpers that hide `registry.define`.
12. Template engines.
13. CSS-in-JS runtimes.

## 8. File and module shape

Canonical folder:

```text
src/components/tch-ui-button/
  index.ts
  tch-ui-button.ts
  tch-ui-button.scss
```

Rules:

1. Folder name equals tag name.
2. Component source file equals tag name plus `.ts`.
3. Component SCSS file equals tag name plus `.scss`.
4. `index.ts` re-exports only public symbols.
5. `index.ts` MUST NOT register the element.
6. The component source module MUST NOT self-register.
7. The component source module MUST NOT import third-party runtime libraries.
8. The component source module MUST NOT import router, store, application service, or global service locator code.
9. Private helpers MAY live beside the component only when they reduce local complexity and remain non-framework primitives.

Canonical public exports:

1. `TCH_UI_BUTTON_TAG_NAME`.
2. Public event name constants, if any.
3. `TchUiButtonElement`.
4. `defineTchUiButton`.
5. Public event detail types when detail is present.
6. Public domain types that are part of the component API.
7. `HTMLElementTagNameMap` augmentation.

Do not augment `HTMLElementEventMap` for component-specific custom events. Export event constants and detail types instead.

A component MAY export a component-specific event map type when it improves type safety without globally implying that the event is valid on every `HTMLElement`.

Factory functions are not canonical. Use `document.createElement(TCH_UI_BUTTON_TAG_NAME)` with `HTMLElementTagNameMap`. A factory MAY exist only when it enforces a real construction invariant that cannot be expressed through attributes, properties, or methods.

## 9. Naming

### 9.1 Tags

Canonical format:

```text
tch-<area>-<noun>
```

Examples:

```text
tch-ui-button
tch-ui-menu
tch-form-date-field
tch-layout-panel
```

Rules:

1. Prefix is `tch`.
2. Names are lowercase ASCII kebab-case.
3. Names MUST be valid custom element names.
4. Names MUST NOT encode implementation technology.
5. Names MUST NOT encode visual style.
6. Names MUST NOT include version numbers.
7. One tag maps to one class.

### 9.2 Classes

Tag:

```text
tch-ui-button
```

Class:

```ts
TchUiButtonElement;
```

Rules:

1. Class names are PascalCase.
2. Class names end in `Element`.
3. Do not use `Component`, `View`, `Widget`, or `HTMLTch...`.

### 9.3 Constants and functions

```ts
export const TCH_UI_BUTTON_TAG_NAME = 'tch-ui-button' as const;

export const TCH_UI_BUTTON_ACTIVATE_EVENT_NAME = 'tch-ui-button-activate' as const;

export function defineTchUiButton(registry: CustomElementRegistry): void;
```

Rules:

1. Tag constants end in `_TAG_NAME`.
2. Event constants end in `_EVENT_NAME`.
3. Public custom event names use `<tag-name>-<event-name>`.
4. Define functions are named `defineTch<Area><Name>`.
5. Define functions require an explicit `CustomElementRegistry`.
6. No define function has a default registry parameter.

### 9.4 Attributes

Rules:

1. Attribute names are lowercase kebab-case.
2. Boolean attributes use positive names: `disabled`, `open`, `selected`, `required`.
3. Do not invent negative booleans such as `not-disabled`.
4. Do not use `data-*` for public component API.
5. Public attributes are stable API.

### 9.5 Properties and methods

Rules:

1. Property names are lower camel case.
2. Method names are lower camel case.
3. Public methods are only for imperative commands or platform-like operations.
4. Prefer properties and events over callback properties.
5. Do not expose broad mutable options bags by default.

### 9.6 Slots, parts, refs, states, CSS properties

Rules:

1. Slot names are lowercase kebab-case.
2. Part names are lowercase kebab-case.
3. `data-ref` names are lowercase kebab-case.
4. Custom state names are lowercase kebab-case.
5. Public CSS custom properties use `--<tag-name>-<name>`.
6. Internal CSS custom properties use `--_<name>`.
7. Internal classes and IDs are not public API.

## 10. Registration

Registration is explicit.

Canonical function:

```ts
export function defineTchUiButton(registry: CustomElementRegistry): void {
  registry.define(TCH_UI_BUTTON_TAG_NAME, TchUiButtonElement);
}
```

Rules:

1. Every component exports exactly one define function.
2. The define function requires a `CustomElementRegistry`.
3. The define function calls `registry.define(...)` directly.
4. The define function does not call `registry.get()` as a production guard.
5. Duplicate registration is a programmer error.
6. Component modules never call their own define function.
7. Component modules never register as import side effects.
8. Application boundary code owns registration order.
9. Side-effect registration entry points are allowed only at the application boundary and must be explicit lists of define calls.

Forbidden inside component source:

```ts
customElements.define('tch-ui-button', TchUiButtonElement);
```

## 11. Pre-upgrade property policy

Default rule: no pre-upgrade property capture.

Reason: this repository controls registration order. Internal code MUST define elements before assigning properties. Capturing pre-upgrade properties in every component is defensive machinery for trusted internal ordering mistakes.

Rules:

1. Internal code MUST register components before programmatic property assignment.
2. Parser-authored attributes are handled through `observedAttributes`.
3. Pre-upgrade own-property capture MAY be used only for declared integration-boundary components.
4. Components using capture MUST list captured properties explicitly.
5. Components MUST NOT add capture speculatively.

## 12. Shadow DOM

Use Shadow DOM for components that own internal DOM or styles.

Canonical rules:

1. Shadow root mode is `open`.
2. Closed shadow roots are forbidden.
3. Use low-cost DSD-compatible root acquisition.
4. Append the static template only if the root is empty.
5. Validate refs whether the root was created imperatively or already existed.
6. Adopt component stylesheets through `adoptedStyleSheets`.
7. Do not replace the shadow root.
8. Do not treat another component’s shadow root as public API.

Canonical shape:

```ts
this.#root =
  this.shadowRoot ??
  this.attachShadow({
    mode: 'open',
  });

this.#root.adoptedStyleSheets = [stylesheetForDocument(this.ownerDocument)];

if (this.#root.childNodes.length === 0) {
  this.#root.append(this.ownerDocument.importNode(template.content, true));
}

const view = requireDocumentView(this.ownerDocument);

this.#button = requireShadowRef(this.#root, 'button', view.HTMLButtonElement);
```

DSD compatibility is only a source-shape rule. It does not create an SSR or hydration requirement.

### 12.1 `delegatesFocus`

Use `delegatesFocus: true` only when the host represents an interactive control and focusing the host should focus the primary internal control.

Otherwise omit it.

Rules:

1. Do not use focus delegation to hide poor focus design.
2. Test keyboard, pointer, programmatic focus, and visible focus when using it.
3. Do not use `delegatesFocus` for noninteractive layout components.

## 13. Realm and document ownership

Canonical rule: component-owned stylesheets and DOM constructor checks are document/realm-aware.

Rules:

1. Use `this.ownerDocument` for component document ownership.
2. Use `document.defaultView` constructors for `instanceof`.
3. Cache stylesheets per `Document`.
4. Re-adopt stylesheets in `adoptedCallback`.
5. Do not use global `HTMLButtonElement`, `HTMLInputElement`, or similar constructors in authoritative ref checks.
6. Do not create a module-level `new CSSStyleSheet()`.

Canonical document view helper:

```ts
export function requireDocumentView(document: Document): Window {
  const view = document.defaultView;

  if (view === null) {
    throw new TypeError('Document has no defaultView.');
  }

  return view;
}
```

## 14. SCSS source and constructable stylesheets

Component SCSS is authored as SCSS and imported as CSS text.

Canonical import:

```ts
import cssSource from './tch-ui-button.scss?source';
```

Rules:

1. `.scss?source` is mandatory for component shadow styles.
2. Component source consumes CSS text explicitly.
3. No generated `.styles.ts` files by default.
4. No committed generated component CSS files by default.
5. No runtime CSS-in-JS.
6. No per-instance `<style>` tags for ordinary component styles.
7. No global CSS extraction for component shadow styles.
8. No CSS Modules for shadow styles.
9. No dynamic CSS rule generation.

Canonical stylesheet primitive:

```ts
export function createComponentStylesheet(cssSource: string): (document: Document) => CSSStyleSheet {
  const stylesheetByDocument = new WeakMap<Document, CSSStyleSheet>();

  return (document: Document): CSSStyleSheet => {
    const existing = stylesheetByDocument.get(document);

    if (existing !== undefined) {
      return existing;
    }

    const view = requireDocumentView(document);
    const stylesheet = new view.CSSStyleSheet();

    stylesheet.replaceSync(cssSource);
    stylesheetByDocument.set(document, stylesheet);

    return stylesheet;
  };
}
```

Rules:

1. Create at most one stylesheet per document per component.
2. Use `WeakMap<Document, CSSStyleSheet>`.
3. Use `document.defaultView.CSSStyleSheet`.
4. Adopt the document-specific stylesheet in the shadow root.
5. Re-adopt in `adoptedCallback`.
6. Do not create a stylesheet per instance.
7. Do not call `replaceSync()` in render.
8. Do not mutate shared stylesheets for per-instance state.

Constructed stylesheets are shared through `adoptedStyleSheets` and are the correct primitive for component shadow styles in this browser baseline.

## 15. Static templates

Templates are static authored HTML.

Canonical source:

```ts
const template = document.createElement('template');

template.innerHTML = `
  <button data-ref="button" part="button" type="button">
    <span data-ref="label" part="label">
      <slot></slot>
    </span>
  </button>
`;
```

Rules:

1. Module-level static templates are canonical.
2. Per-document template caches are not canonical.
3. Template source MUST be static.
4. Template source MUST NOT contain `${...}`.
5. Template source MUST NOT concatenate runtime values.
6. Template source MUST NOT include user, network, storage, URL, serialized, or runtime data.
7. Static template creation is the only ordinary component-local HTML parsing sink.
8. Insert template content with `this.ownerDocument.importNode(template.content, true)`.
9. Render MUST NOT parse HTML.
10. Render MUST NOT assign `innerHTML`.
11. Render MUST NOT use a runtime template DSL.
12. Render MUST NOT use virtual DOM.
13. Dynamic text uses `textContent`.
14. Dynamic attributes use DOM attribute APIs.
15. Dynamic properties use DOM properties.
16. Dynamic lists use explicit keyed DOM operations.

Template source may be split into adjacent static string literals only when there is no runtime value interpolation and review can still verify the complete static markup.

Module-level static templates are acceptable because this repository has no SSR requirement, component modules run in browser source, templates are inert, and cloned content is imported into the component’s owner document.

## 16. Typed shadow refs

Shadow refs are the canonical bridge from static untyped DOM to typed TypeScript fields.

Canonical helper:

```ts
type ElementConstructor<T extends Element> = {
  new (...args: never[]): T;
};

export function requireShadowRef<T extends Element>(root: ShadowRoot, ref: string, constructor: ElementConstructor<T>): T {
  const elements = root.querySelectorAll(`[data-ref="${ref}"]`);

  if (elements.length !== 1) {
    throw new TypeError(`Expected exactly one shadow ref "${ref}", found ${elements.length}.`);
  }

  const element = elements.item(0);

  if (!(element instanceof constructor)) {
    throw new TypeError(`Invalid shadow ref type: ${ref}`);
  }

  return element;
}
```

Canonical use:

```ts
const view = requireDocumentView(this.ownerDocument);

this.#button = requireShadowRef(this.#root, 'button', view.HTMLButtonElement);
```

Rules:

1. `data-ref` values MUST be unique per shadow root.
2. Duplicate refs are static-template programmer errors.
3. Missing refs are static-template programmer errors.
4. Wrong element types are static-template programmer errors.
5. Use constructors from `ownerDocument.defaultView`.
6. Capture refs once.
7. Store refs in `#private` fields.
8. Never query refs during render.
9. Never expose refs publicly.
10. Do not use this helper for external DOM.

`data-ref` is internal implementation metadata. It is not public API.

## 17. Component source skeleton

This skeleton is authoritative in shape. Component-specific behavior may differ.

```ts
import { createComponentStylesheet, requireDocumentView, requireShadowRef } from '../internal/dom-primitives';
import cssSource from './tch-ui-button.scss?source';

export const TCH_UI_BUTTON_TAG_NAME = 'tch-ui-button' as const;

export const TCH_UI_BUTTON_ACTIVATE_EVENT_NAME = 'tch-ui-button-activate' as const;

const ATTRIBUTE = {
  disabled: 'disabled',
} as const satisfies Record<string, string>;

const stylesheetForDocument = createComponentStylesheet(cssSource);

const template = document.createElement('template');

template.innerHTML = `
  <button data-ref="button" part="button" type="button">
    <span data-ref="label" part="label">
      <slot></slot>
    </span>
  </button>
`;

export type TchUiButtonActivateDetail = Readonly<{
  trigger: 'click';
}>;

export type TchUiButtonActivateEvent = CustomEvent<TchUiButtonActivateDetail>;

export class TchUiButtonElement extends HTMLElement {
  static readonly observedAttributes = [ATTRIBUTE.disabled] as const;

  readonly #root: ShadowRoot;
  readonly #button: HTMLButtonElement;

  #disabled = false;

  readonly #onButtonClick = (event: MouseEvent): void => {
    if (this.#disabled) {
      event.preventDefault();
      return;
    }

    this.dispatchEvent(
      new CustomEvent<TchUiButtonActivateDetail>(TCH_UI_BUTTON_ACTIVATE_EVENT_NAME, {
        bubbles: true,
        composed: true,
        detail: {
          trigger: 'click',
        },
      }),
    );
  };

  constructor() {
    super();

    this.#root =
      this.shadowRoot ??
      this.attachShadow({
        mode: 'open',
        delegatesFocus: true,
      });

    this.#root.adoptedStyleSheets = [stylesheetForDocument(this.ownerDocument)];

    if (this.#root.childNodes.length === 0) {
      this.#root.append(this.ownerDocument.importNode(template.content, true));
    }

    const view = requireDocumentView(this.ownerDocument);

    this.#button = requireShadowRef(this.#root, 'button', view.HTMLButtonElement);

    this.#button.addEventListener('click', this.#onButtonClick);
  }

  get disabled(): boolean {
    return this.#disabled;
  }

  set disabled(value: boolean) {
    this.#setDisabled(value, true);
  }

  adoptedCallback(): void {
    this.#root.adoptedStyleSheets = [stylesheetForDocument(this.ownerDocument)];
  }

  attributeChangedCallback(name: string, oldValue: string | null, newValue: string | null): void {
    if (oldValue === newValue) {
      return;
    }

    if (name === ATTRIBUTE.disabled) {
      this.#setDisabled(newValue !== null, false);
      return;
    }

    throw new TypeError(`Unexpected observed attribute: ${name}`);
  }

  #setDisabled(value: boolean, reflect: boolean): void {
    if (this.#disabled === value) {
      return;
    }

    this.#disabled = value;

    if (reflect) {
      this.toggleAttribute(ATTRIBUTE.disabled, value);
    }

    this.#renderDisabled();
  }

  #renderDisabled(): void {
    this.#button.disabled = this.#disabled;
  }
}

export function defineTchUiButton(registry: CustomElementRegistry): void {
  registry.define(TCH_UI_BUTTON_TAG_NAME, TchUiButtonElement);
}

declare global {
  interface HTMLElementTagNameMap {
    'tch-ui-button': TchUiButtonElement;
  }
}
```

Rules illustrated:

1. Direct `HTMLElement` subclass.
2. No base class.
3. No decorators.
4. No self-registration.
5. Explicit registry parameter.
6. `.scss?source` import.
7. Per-document stylesheet cache.
8. Module-level static template.
9. Owner-document template import.
10. DSD-compatible open shadow root.
11. Template append only when root is empty.
12. Realm-safe constructors.
13. Exact-one ref extraction.
14. No non-null assertions.
15. No trusted-setter runtime type assertion.
16. Serialized attribute parsing.
17. Direct DOM patching.
18. Hyphen-only public event name.
19. Exported event detail type.
20. No `HTMLElementEventMap` augmentation.

## 18. Constructor

Constructor MAY:

1. Call `super()`.
2. Attach `ElementInternals` if needed.
3. Acquire or attach the open shadow root.
4. Adopt the component stylesheet.
5. Append the static template if the shadow root is empty.
6. Capture typed shadow refs.
7. Initialize private fields.
8. Construct narrow local primitives.
9. Attach listeners to owned internal nodes when their lifetime is the element instance.

Constructor MUST NOT:

1. Read attributes as source of component state.
2. Read light DOM children.
3. Read slotted content.
4. Read layout.
5. Fetch.
6. Read storage.
7. Start timers.
8. Start observers.
9. Start animation frames.
10. Attach listeners to `window`, `document`, application roots, or external nodes.
11. Dispatch events.
12. Register custom elements.
13. Access application services.
14. Import or access router/store state.
15. Perform business side effects.

Constructor listener policy:

1. Internal shadow-node listeners MAY be attached in the constructor only when the target is owned by the component and the listener lifetime is the element instance.
2. External listeners MUST be connection-scoped.
3. Listeners whose behavior depends on connection state SHOULD be connection-scoped even if the target is internal.

## 19. Lifecycle

### 19.1 `connectedCallback`

Use only for connection-scoped work:

1. External event listeners.
2. Observers.
3. Timers.
4. Animation frames.
5. Async operations tied to connection.
6. Slot validation when behavior depends on slotted content.
7. Measurement that requires connection.
8. Form/label synchronization that requires connection.

Rules:

1. MUST tolerate repeated connect/disconnect cycles.
2. MUST NOT duplicate resources.
3. MUST NOT create hidden application dependencies.
4. MUST NOT scan global DOM as discovery.
5. MUST use cleanup or abort for every connection-scoped resource.

### 19.2 `disconnectedCallback`

Use for cleanup:

1. Abort external listeners.
2. Disconnect observers.
3. Clear timers.
4. Cancel animation frames.
5. Abort connection-scoped async work.
6. Release external DOM references.
7. Revoke owned object URLs.

Rules:

1. MUST preserve component state unless the public contract says otherwise.
2. MUST NOT destroy shadow DOM merely because the element disconnected.
3. MUST NOT dispatch routine lifecycle events.
4. MUST tolerate disconnect after partial connection setup.

### 19.3 `adoptedCallback`

Styled components MUST implement `adoptedCallback()` to re-adopt the document-specific constructable stylesheet:

```ts
adoptedCallback(): void {
  this.#root.adoptedStyleSheets = [
    stylesheetForDocument(this.ownerDocument)
  ];
}
```

Rules:

1. Re-adopt stylesheets for `this.ownerDocument`.
2. Update document-bound resource references if any.
3. Preserve state.
4. Do not recreate the shadow tree.

### 19.4 `attributeChangedCallback`

Rules:

1. Return when `oldValue === newValue`.
2. Parse only the changed attribute.
3. Validate present serialized values.
4. Update private typed state.
5. Patch or schedule render.
6. Do not fetch.
7. Do not read layout.
8. Do not dispatch user-action events for programmatic attribute changes.
9. Throw for unexpected observed attributes.

### 19.5 `connectedMoveCallback`

Ordinary component correctness MUST NOT depend on `connectedMoveCallback`.

`moveBefore()` and `connectedMoveCallback()` are repository-admission-only. If admitted, they MAY optimize moves, but components MUST remain correct under normal disconnect/connect movement.

## 20. Resource ownership

Every resource has an owner and a lifetime.

Instance lifetime:

1. Shadow root.
2. Internal static DOM refs.
3. Private state.
4. Owned internal listeners that do not depend on connection.
5. Per-instance narrow primitives.

Connection lifetime:

1. External listeners.
2. Window/document listeners.
3. Observers.
4. Timers.
5. Animation frames.
6. Media query listeners.
7. Connection-scoped fetches.
8. Subscriptions.
9. External DOM references.

Operation lifetime:

1. Supersedable fetches.
2. Validation requests.
3. Search requests.
4. Animations.
5. Deferred measurements.
6. Any async work where a later operation makes an earlier result stale.

Any pending promise continuation that can observe component state after disconnect is an operation-lifetime concern even if the underlying platform API cannot be canceled.

Canonical external listener pattern:

```ts
#connectionAbort: AbortController | undefined;

readonly #onWindowResize = (): void => {
  this.#measureAfterResize();
};

connectedCallback(): void {
  if (this.#connectionAbort !== undefined) {
    return;
  }

  const abortController = new AbortController();
  this.#connectionAbort = abortController;

  window.addEventListener(
    "resize",
    this.#onWindowResize,
    {
      signal: abortController.signal
    }
  );
}

disconnectedCallback(): void {
  this.#connectionAbort?.abort();
  this.#connectionAbort = undefined;
}
```

Rules:

1. Do not retain external DOM nodes after disconnect unless explicitly owned.
2. Do not use `FinalizationRegistry` for routine cleanup.
3. Do not use `MutationObserver` as a reactivity system.
4. Do not create unbounded observers.
5. Non-abortable APIs require explicit cleanup fields.
6. Object URLs created by a component MUST be revoked by the component.
7. Media query listeners are connection-scoped.
8. `requestAnimationFrame` IDs are canceled if pending at disconnect.
9. Timers are cleared if pending at disconnect.
10. Observers are disconnected at disconnect.

## 21. Async stale-commit policy

Every async operation that can become irrelevant MUST use one of:

1. `AbortController`.
2. A sequence token.
3. Both.

Rules:

1. Starting a superseding operation aborts or invalidates the old one.
2. After every `await`, check staleness before committing state or DOM.
3. Disconnect aborts connection-scoped async work.
4. Stale results are ignored.
5. Own abort errors are not user-visible failures.
6. Unknown async errors MUST NOT be swallowed silently.
7. Render MUST NOT be committed from a stale async result.
8. Event dispatch MUST NOT occur from a stale async result.

Canonical token pattern:

```ts
#loadSequence = 0;

async #loadData(): Promise<void> {
  const sequence = ++this.#loadSequence;
  const result = await this.#fetchData();

  if (sequence !== this.#loadSequence || !this.isConnected) {
    return;
  }

  this.#data = result;
  this.#renderData();
}
```

## 22. State ownership

Rules:

1. Private fields are the source of truth.
2. DOM is not the source of truth except for native editable controls at the user-input boundary.
3. Public properties update private state.
4. Observed attributes parse into private state.
5. Internal user events update private state.
6. Render reflects private state to DOM.
7. Derived state is computed unless caching is justified.
8. Cached derived state MUST have explicit invalidation.
9. Do not duplicate state without a documented source-of-truth rule.
10. Do not expose mutable internal state.
11. Do not store application-wide state in components.
12. Do not import stores.
13. Do not import routers.
14. Do not import application services.
15. Do not hide I/O in getters, setters, or render.

External object dispatch rule:

1. Immutable domain data MAY be stored by reference.
2. Mutable caller-owned data MUST be cloned once or rejected.
3. Hostile serialized data MUST be validated before reaching component APIs.
4. If ownership is unclear, redesign the API.
5. Component code MUST NOT mutate caller-owned objects unless the API explicitly transfers ownership.

## 23. Attributes and properties

Properties are primary for trusted internal TypeScript code. Attributes are serialized DOM API.

Use a property for:

1. Objects.
2. Arrays.
3. Domain entities.
4. Non-serialized values.
5. High-frequency state.
6. Values not meaningful in markup.
7. Values not intended for CSS selectors.

Use an attribute for:

1. HTML-authored configuration.
2. Boolean platform-like state.
3. Small enums.
4. Values meaningful to CSS selectors.
5. Values needed before application property assignment.
6. Standard HTML-like concepts: `disabled`, `open`, `checked`, `value`, `name`, `required`.

### 23.1 Boolean attributes

Rules:

1. Presence means true.
2. Absence means false.
3. `"false"` still means true when present.
4. Reflect with `toggleAttribute`.

### 23.2 Enum attributes

Rules:

1. Values are lowercase kebab-case.
2. Present invalid values fail fast.
3. Absence maps to documented default.
4. Internal type is a literal union.

### 23.3 Numeric attributes

Rules:

1. Parse finite numbers only.
2. Reject `NaN`, `Infinity`, and `-Infinity`.
3. Enforce bounds at the attribute boundary.
4. Present invalid values fail fast.
5. Absence maps to documented default.

### 23.4 String attributes

Rules:

1. Unconstrained string attributes may accept any string.
2. Constrained string attributes validate at parse time.
3. Empty string is a value, not absence, unless the contract says otherwise.
4. Do not use JSON-in-attributes.

### 23.5 Reflection

Rules:

1. Reflect only when the attribute is real public DOM contract.
2. Do not reflect every property.
3. Avoid reflection loops with a centralized setter.
4. Programmatic property changes do not dispatch user-action events.

Canonical state/reflection pattern:

```ts
#setOpen(value: boolean, reflect: boolean): void {
  if (this.#open === value) {
    return;
  }

  this.#open = value;

  if (reflect) {
    this.toggleAttribute("open", value);
  }

  this.#renderOpen();
}
```

### 23.6 Invalid attribute policy

Default rule: present invalid constrained serialized configuration fails fast.

This rule applies to trusted internal authored markup and trusted internal code mutating component attributes. In this repository, invalid enum, invalid finite-number, invalid token, invalid constrained string, and invalid constrained URL attributes are programmer errors. They MUST NOT silently map to defaults.

Absent attributes are different from invalid present attributes:

1. Absence maps to the documented default.
2. Presence with invalid constrained value fails fast.
3. Empty string is valid only when the attribute contract says it is valid.
4. Boolean attributes are valid by presence alone.

Hostile or user-controlled serialized values MUST be validated before they are written to component attributes. If a component is explicitly designed as a hostile-boundary component, its invalid serialized input policy MUST be one of:

1. Reject before mutation.
2. Enter a documented inert state.
3. Use form validity state for user-entered form values.

The following are forbidden:

1. Silently mapping unknown enum values to default.
2. Silently clamping invalid numeric configuration.
3. Treating `"false"` as false for boolean attributes.
4. Parsing JSON from attributes.
5. Logging a warning instead of enforcing the contract.

## 24. Custom states

`ElementInternals.states` / `CustomStateSet` is admitted for latest-stable-browser source use.

Canonical state names are lower-kebab-case identifiers without a leading `--`.

Examples:

```ts
this.#internals.states.add('busy');
this.#internals.states.delete('busy');
```

```css
:host(:state(busy)) {
  cursor: progress;
}
```

Rules:

1. Attach `ElementInternals` only when needed for forms, host accessibility defaults, or custom states.
2. Use attributes for public serialized state.
3. Use custom states for CSS-visible nonserialized boolean state.
4. Keep purely internal render state private.
5. Do not mirror every private field into custom states.
6. Custom states are public styling API if documented.
7. Custom state names MUST be lower-kebab-case.
8. Custom state names MUST NOT use a `--` prefix.
9. Custom states MUST NOT replace required ARIA or form state updates.
10. Custom states MUST NOT be used for values, objects, counts, labels, or user data.

Dispatch rule:

1. If the state must be authored in HTML, use an attribute.
2. If the state must be inspected from markup or serialized state, use an attribute.
3. If the state is CSS-visible but not serialized API, use a custom state.
4. If the state is only implementation logic, keep it private.
5. If the state affects accessibility, update the appropriate accessibility state in addition to any custom state.

## 25. Rendering

Rendering is direct DOM patching from private state to owned DOM.

Rules:

1. Render methods are private.
2. Render methods are idempotent.
3. Render methods patch captured refs.
4. Render methods do not query refs.
5. Render methods do not parse HTML.
6. Render methods do not replace the shadow tree.
7. Render methods do not dispatch events.
8. Render methods do not fetch.
9. Render methods do not read or write storage.
10. Render methods do not perform feature detection.
11. Render methods avoid layout reads.
12. Preserve focus.
13. Preserve selection.
14. Preserve scroll position.
15. Preserve IME composition state.
16. Do not overwrite active editable values during composition unless the component contract requires it.
17. Prefer attributes, properties, `hidden`, `inert`, and CSS state over DOM replacement.

### 25.1 Render timing dispatch

Use synchronous patch when:

1. A state change updates one independent DOM sink.
2. A public method guarantees immediately observable DOM state.
3. Form validity or focus correctness requires immediate update.

Use microtask batching when:

1. Multiple property/attribute changes can coalesce.
2. Render output depends on combined state.
3. There is no immediate DOM-observability requirement.

Use `requestAnimationFrame` when:

1. Layout measurement is required after DOM writes.
2. High-frequency visual writes must align with frames.
3. Animation or scroll-position writes are involved.

Do not use microtask batching as a hidden reactive runtime.

Canonical local microtask pattern:

```ts
#renderQueued = false;

#requestRender(): void {
  if (this.#renderQueued) {
    return;
  }

  this.#renderQueued = true;

  queueMicrotask(() => {
    this.#renderQueued = false;
    this.#render();
  });
}
```

### 25.2 Lists

Rules:

1. Do not render lists with HTML strings.
2. Use stable keys.
3. Reuse existing nodes.
4. Remove nodes not present.
5. Insert nodes in required order.
6. Do not destroy focused descendants unless the item itself was removed.
7. Keep list rendering local unless multiple components share the exact same algorithm.

## 26. Events

Events are explicit public API.

Public component custom events MUST use:

1. Exported `*_EVENT_NAME` constants.
2. Exported detail types when detail is present.
3. Hyphen-only names.
4. Dispatch from the host element.
5. `bubbles: true`.
6. `composed: true`.
7. Fresh plain data detail, or no detail.

Rationale: public component events are meant to be observable outside component internals, across Shadow DOM boundaries, and through ancestor delegation. A signal that must not escape the component is not a public event.

Public component events MUST NOT become a hidden event bus, service channel, request/response RPC mechanism, or implicit application-wide coordination layer. A parent component MAY listen to a child component’s public event when it is explicitly consuming that child’s public DOM contract. Internal implementation coordination uses non-composed internal events, explicit properties, explicit methods, or parent-owned orchestration code.

Rules:

1. Every public custom event has an exported `*_EVENT_NAME` constant.
2. Every public custom event with detail has an exported detail type.
3. Public custom events are dispatched from the host element.
4. Public custom event names use `<tag-name>-<event-name>`.
5. Public custom events MUST set `bubbles: true`.
6. Public custom events MUST set `composed: true`.
7. Internal events MUST NOT cross shadow boundaries.
8. Event detail MUST be minimal.
9. Event detail MUST NOT expose internal DOM nodes.
10. Event detail MUST NOT expose mutable internal objects.
11. Event detail MUST NOT expose privileged capabilities.
12. Programmatic property changes MUST NOT emit user-action events.
13. Do not dispatch events in constructors.
14. Do not dispatch events from render.
15. Do not use public events as request/response RPC.

### 26.1 Event detail immutability

Canonical policy:

1. Event detail is a fresh plain data object.
2. Detail types are `Readonly<...>` at the TypeScript surface.
3. Detail MUST contain no internal mutable references.
4. Detail MUST NOT be reused across dispatches.
5. `Object.freeze` is not required by default.
6. Use `Object.freeze` only for explicit security-boundary event contracts or when a mutable object graph would otherwise leak.

A component MAY export a component-specific event map type when it improves typing for internal listeners without augmenting global `HTMLElementEventMap`.

### 26.2 Canonical event

```ts
export const TCH_UI_MENU_SELECT_EVENT_NAME = 'tch-ui-menu-select' as const;

export type TchUiMenuSelectDetail = Readonly<{
  value: string;
}>;

this.dispatchEvent(
  new CustomEvent<TchUiMenuSelectDetail>(TCH_UI_MENU_SELECT_EVENT_NAME, {
    bubbles: true,
    composed: true,
    detail: {
      value,
    },
  }),
);
```

### 26.3 Cancelable before-events

Cancelable public before-events also bubble and compose.

```ts
const accepted = this.dispatchEvent(
  new CustomEvent<TchUiMenuSelectDetail>('tch-ui-menu-before-select', {
    bubbles: true,
    composed: true,
    cancelable: true,
    detail: {
      value,
    },
  }),
);

if (!accepted) {
  return;
}

if (!this.isConnected) {
  return;
}

this.#commitSelection(value);
```

Rules:

1. Cancelable events are only for pre-action decisions.
2. If canceled, do not commit the action.
3. After `dispatchEvent()`, external code may have changed state or removed the element.
4. Recheck state, connection, and cancellation before continuing.
5. Do not emit the after-event if the before-event was canceled.

### 26.4 Native events

Use native event names only when implementing native-like semantics.

Rules:

1. Form-like controls use `input` and `change` according to native semantics.
2. Otherwise use namespaced custom events.
3. Do not use generic public custom names like `select`, `close`, `change`, or `toggle`.

## 27. Slots

Slots are public composition API for consumer-owned DOM.

Rules:

1. Use the default slot only for primary content.
2. Use named slots for stable named regions.
3. Slot names are public API.
4. Slotted DOM is external DOM.
5. Do not mutate slotted nodes.
6. Do not attach deep listeners inside slotted DOM unless the slot contract requires it.
7. Use `slotchange` only when behavior depends on assigned nodes.
8. Validate assigned nodes if behavior depends on their shape.
9. Do not use `MutationObserver` as slot reactivity.
10. Use properties for data and slots for DOM content.
11. Treat slotted custom elements as external code.
12. Required slots MUST be validated.
13. Required slot absence is a programmer error unless the component has a documented inert state.
14. Fallback content MUST NOT mask a missing required accessible name.
15. Interactive slotted content inside an interactive component is forbidden unless the component is an explicit composite widget.

If a component only displays slotted content, no validation is required.

If a component reads, counts, classifies, labels, disables, invokes, moves, or derives behavior from slotted nodes, validation is required at `slotchange` or at the public method boundary.

## 28. Forms

Use form-associated custom elements only when the host itself is semantically a form control.

Rules:

1. Use native form controls inside shadow DOM when possible.
2. Use `ElementInternals` when the host must participate in form submission, labels, validation, reset, or restore.
3. Use `static readonly formAssociated = true` only for actual form controls.
4. Call `attachInternals()` in the constructor for form-associated components.
5. Use `setFormValue()` whenever the submitted value changes.
6. Use `setValidity()` whenever validity changes.
7. Implement form callbacks when relevant:
   - `formAssociatedCallback`
   - `formDisabledCallback`
   - `formResetCallback`
   - `formStateRestoreCallback`

8. Programmatic value changes do not dispatch `input` or `change`.
9. User edits dispatch native-compatible `input` and `change` when the component behaves like a native input.
10. Disabled state suppresses interaction and submission according to native-like semantics.
11. Invalid user-entered values use validity state, not developer-error throwing.
12. Invalid component configuration fails fast.

### 28.1 Native-like value and checked-state models

This section applies only to form-associated custom elements that intentionally model native input-like controls. Components that are not native-like input equivalents MUST NOT cargo-cult `value`, `defaultValue`, dirty state, `input`, or `change` semantics.

A text-like or value-like control whose public current value is named `value` MUST implement a dirty-value model.

Internal state for value-like controls:

1. `#value`: current live value.
2. `#defaultValue`: reset/default value.
3. `#dirtyValue`: whether the live value has diverged from the default value because of user edit, programmatic `value` assignment, or state restore.
4. Validity state derived from `#value`.
5. Submitted value derived from `#value`.

Public API for value-like controls:

1. `value` property exposes the live value.
2. `defaultValue` property exposes the default value.
3. `value` attribute represents the default value.
4. `name` controls submission naming for single-value submission.
5. `required` affects validity.
6. `disabled` prevents interaction and submission.

Rules for value-like controls:

1. Initial `#defaultValue` is initialized from the `value` attribute or documented default.
2. Initial `#value` is initialized from `#defaultValue`.
3. Setting the `value` attribute updates `#defaultValue`.
4. Setting the `value` attribute updates `#value` only when `#dirtyValue` is false.
5. Setting the `defaultValue` property updates `#defaultValue`, reflects the `value` attribute, and updates `#value` only when `#dirtyValue` is false.
6. Setting the `value` property updates `#value`, sets `#dirtyValue` to true, updates form value, updates validity, and renders.
7. Setting the `value` property MUST NOT update the `value` attribute.
8. User edits update `#value`, set `#dirtyValue` to true, update form value, update validity, render, and dispatch `input` according to native-like semantics.
9. User commit dispatches `change` according to native-like semantics.
10. Programmatic `value` assignment dispatches neither `input` nor `change`.
11. `formResetCallback()` sets `#value` to `#defaultValue`, sets `#dirtyValue` to false, updates form value, updates validity, and renders without dispatching `input` or `change`.
12. `formStateRestoreCallback(state, reason)` validates restored state, applies it to `#value`, sets `#dirtyValue` to true, updates form value, updates validity, and renders without dispatching `input` or `change`.

A checkbox-like, toggle-like, option-like, or selected-state control MUST implement the analogous native-like state model instead of forcing a text-like value model.

Rules for checked/selected-state controls:

1. The live state is represented by a property such as `checked` or `selected`.
2. The default state is represented by a property such as `defaultChecked` or `defaultSelected` when the native analogue has one.
3. The corresponding attribute represents the default state, not necessarily the live state, when matching native semantics.
4. A dirty checked/selected flag tracks divergence from the default state.
5. User edits update the live state, set the dirty flag, update form value, update validity, render, and dispatch native-like events.
6. Programmatic live-state assignment dispatches no user events.
7. Reset restores the live state to the default state and clears the dirty flag.
8. Restore validates restored state and applies it without dispatching user events.
9. Submitted value is derived from the live state and the component’s submission contract.

If the component has no native-like default/live distinction, it MUST document that it is not a native-like input equivalent and MUST NOT pretend to be one.

### 28.2 Submitted value

Rules:

1. Submitted value is derived from live state, not default state.
2. For single string or `File` submitted values, the host `name` is the submission name.
3. For single string or `File` submitted values, no `name` means no submitted entry.
4. `setFormValue(null)` means no submitted value.
5. Disabled means no submitted entry.
6. Multiple submitted values use `FormData`.
7. For `FormData` submitted values, the `FormData` entries provide their own names; the host `name` is not the entry key.
8. A component that submits `FormData` MUST document the submitted entry names.
9. File-like values use `File` only when the component’s public contract and browser security model permit it.
10. Submitted value changes MUST be synchronized before any user event that reports the new value.

### 28.3 Validity

Rules:

1. `required` is validated against the live value.
2. Custom validation is validated against the live value.
3. `setValidity()` reflects the current validity state.
4. User-entered invalid value is represented through validity and accessible error state.
5. Developer-supplied invalid configuration throws.
6. `reportValidity()` MUST NOT be called automatically on every edit.
7. Validity updates MUST be deterministic after property assignment, user edit, reset, and restore.

### 28.4 Disabled

Rules:

1. `disabled` prevents user interaction.
2. `disabled` suppresses submission.
3. `formDisabledCallback(disabled)` propagates disabled state to internal controls.
4. `aria-disabled` alone is insufficient.
5. Disabled state MUST update visual, behavioral, form, and accessibility state consistently.

## 29. Host, internal controls, labels, and accessible object ownership

A component MUST choose exactly one primary accessibility object for each logical control.

The form object and the accessibility object may both be the host, or the form object may be the host while an internal native control is the primary accessibility object. They MUST NOT compete.

External labels target the host. They do not target arbitrary internal shadow controls.

### 29.1 Host-owned accessibility model

Use this model when the host is the logical accessible object.

Rules:

1. The host carries role, name, value, and state.
2. Use `ElementInternals` for host form integration and host accessibility defaults where appropriate.
3. External labels associate with the host.
4. The host is the public focus target, or focus delegation is explicitly part of the host focus contract.
5. Internal implementation controls MUST NOT expose a second competing accessible control.
6. Internal implementation controls MUST NOT be separately tabbable.
7. Internal native controls used only as implementation details MUST be neutralized in a way that does not create hidden focusable content.
8. If a focusable internal native control cannot be neutralized without harming accessibility, use the internal-native-control model instead.
9. Internal native controls MUST NOT be neutralized by applying `aria-hidden` while they remain focusable or operable.

### 29.2 Internal-native-control accessibility model

Use this model when the internal native control is the logical accessible object.

Rules:

1. The internal native control carries role, name, value, and state.
2. The host MUST NOT expose a competing role/name/value for the same logical control.
3. The host MAY still be the form-associated object through `ElementInternals`.
4. The public label source MUST be forwarded deterministically to the internal native control.
5. Label forwarding MUST NOT depend on arbitrary external DOM traversal.
6. If external labels are accepted, the component MUST define exactly how they become the internal control’s accessible name.
7. If deterministic forwarding is not possible, require a component-owned label source such as a label slot, `label` attribute/property, or `aria-label` contract.

### 29.3 Label sources

Allowed label sources:

1. External labels associated with the host, when using the host-owned model.
2. A documented label slot.
3. A documented `label` attribute or property.
4. `aria-label` or `aria-labelledby` on the host, when the component contract supports it.
5. Internal visible text owned by the component.

Rules:

1. A form control without an accessible name is nonconforming.
2. Fallback slot content MUST NOT mask a missing required accessible name.
3. Label forwarding MUST be deterministic and reviewed as part of the component contract.
4. Do not create two accessible names for one logical control.
5. Do not expose two focusable controls for one logical control.
6. Do not rely on internal shadow IDs being targeted by external labels.

If neither host-owned nor internal-native-control ownership is clean, redesign the component.

## 30. Accessibility

Accessibility is correctness.

Rules:

1. Prefer native elements.
2. Use `<button>` for button behavior.
3. Use `<a href>` for navigation.
4. Use native input controls when semantics match.
5. Do not use `div role="button"` when a native `button` works.
6. Every interactive component MUST define role, name, value, state, keyboard behavior, and focus behavior.
7. A nameless interactive control is nonconforming.
8. Do not use positive `tabindex`.
9. Preserve visible focus.
10. Do not remove outlines without an equivalent replacement.
11. Do not trap focus except for modal or composite patterns that require it.
12. Do not auto-focus on connection.
13. Disabled state MUST match behavior and accessibility state.
14. Required, invalid, expanded, selected, checked, pressed, current, and busy states MUST match behavior.
15. Touch, pointer, mouse, and keyboard behavior MUST converge on the same state transitions.
16. Motion MUST respect reduced-motion preferences.
17. Forced-colors MUST remain usable where relevant.
18. Hidden focusable content is nonconforming.
19. `aria-hidden` MUST NOT hide focusable content.
20. `inert` MAY be used for modal/inactive subtrees when behavior requires it.

Dispatch rule:

1. If native semantics are correct, use native elements.
2. If the host itself must carry semantics, use `ElementInternals` where appropriate.
3. If neither native semantics nor `ElementInternals` can express the widget, implement the correct ARIA pattern explicitly.
4. Do not invent semantics.

## 31. Focus

Rules:

1. Focus changes only from user action or explicit public method.
2. Do not focus in constructor.
3. Do not focus automatically in `connectedCallback`.
4. Do not use positive `tabindex`.
5. Use roving tabindex only for valid composite widgets.
6. Use `aria-activedescendant` only when the pattern requires focus to remain on one element.
7. Do not mix roving tabindex and `aria-activedescendant` without a documented composite-widget reason.
8. Focus traps are allowed only for modal patterns.
9. Restore focus after modal close only when the previous focus target is still connected and focusable.
10. Focus indicators MUST work in forced-colors.
11. Shadow DOM focus behavior MUST be part of the public accessibility contract.
12. `delegatesFocus` MUST be justified by the host focus contract.
13. Hidden content MUST NOT contain focusable descendants.
14. Disabled controls MUST NOT remain keyboard-operable.
15. `aria-disabled` controls that remain focusable MUST block activation and expose disabled state consistently.
16. Programmatic `focus()` methods MUST preserve the component’s declared host-versus-internal-control focus model.

Focus dispatch rule:

1. If the host is the primary accessibility object, host focus behavior is canonical.
2. If an internal native control is the primary accessibility object, internal focus behavior is canonical and the host MUST NOT expose a competing focus target.
3. If the component is a composite widget, use the ARIA pattern’s focus model exactly.
4. If focus restoration target is gone or not focusable, do not guess a new target unless the component contract defines a fallback.

## 32. SCSS, layout, directionality, and theming

Component SCSS is shadow-local.

Rules:

1. Start with `:host`.
2. Define host display explicitly.
3. Preserve hidden semantics:

```css
:host([hidden]) {
  display: none;
}
```

4. Use internal classes only inside the shadow tree.
5. Internal classes are not public API.
6. Use `part` only for intentional public styling hooks.
7. Use public CSS custom properties only for intentional external styling hooks.
8. Use `::slotted()` only for shallow slot styling.
9. Do not style `html`, `body`, or application selectors.
10. Do not declare global resets in component SCSS.
11. Do not use `@font-face` in component SCSS.
12. Prefix `@keyframes` with the tag name.
13. Respect `prefers-reduced-motion`.
14. Respect forced-colors.
15. Do not concatenate untrusted values into CSS.
16. Do not use `:host-context()` for theming.
17. Use CSS custom properties for theming.
18. Use attributes or custom states for finite visual states.
19. Use cascade layers when they clarify internal style ordering.
20. Use container queries when the component’s layout should depend on its own container rather than viewport assumptions.
21. Use modern stable selectors when they improve clarity or correctness.

### 32.1 Directionality

Rules:

1. Use logical properties by default:
   - `margin-inline`
   - `padding-inline`
   - `border-inline`
   - `inset-inline`
   - `inline-size`
   - `block-size`
   - `text-align: start | end`

2. Use physical `left` and `right` only when the meaning is physically directional.
3. Do not force `direction` unless the component’s public contract requires it.
4. Directional icons MUST have explicit RTL behavior.
5. Directional animations MUST define whether they are physical or inline-directional.
6. Host directionality MUST be inherited unless the component contract says otherwise.
7. Components with directional UI MUST support both LTR and RTL source behavior.

## 33. Public styling API

Public styling API is limited to:

1. Public CSS custom properties.
2. `part` names.
3. `exportparts`, when intentionally forwarding parts.
4. Slots.
5. Host attributes.
6. Documented custom states.

Rules:

1. Internal classes are not public API.
2. Internal IDs are not public API.
3. DOM depth is not public API.
4. Anonymous wrappers are not public API.
5. Do not expose a part unless external styling is intended.
6. Do not expose a public CSS custom property unless external tuning is intended.
7. Do not remove or rename parts without an explicit migration decision.
8. Public CSS custom properties MUST be namespaced with the tag name.
9. `exportparts` is public API and MUST be intentional.

## 34. Security

Shadow DOM is not a security boundary. Closed shadow roots are not a security boundary.

Rules:

1. Dynamic HTML is forbidden in ordinary components.
2. User text uses `textContent`.
3. User URLs are validated before use.
4. User CSS strings are rejected.
5. User script strings are rejected.
6. Inline event handler attributes are forbidden.
7. Dynamic tag creation from untrusted strings is forbidden.
8. Slotted custom elements are external code.
9. Do not rely on global IDs or named window properties.
10. Do not expose internals in event detail.
11. `target="_blank"` links require `rel="noopener noreferrer"`.
12. Caller-owned mutable objects MUST NOT be mutated unless ownership transfer is explicit.
13. Security-boundary event detail MUST NOT expose mutable object graphs.

### 34.1 HTML sinks

Forbidden in ordinary components:

1. Dynamic `innerHTML`.
2. Dynamic `outerHTML`.
3. Dynamic `insertAdjacentHTML`.
4. `DOMParser` for untrusted HTML.
5. `setHTMLUnsafe`.
6. Raw rich-HTML string APIs.
7. Component-local experiments with HTML Sanitizer or `Element.setHTML`.

Static template `innerHTML` is allowed only for no-interpolation authored markup.

HTML Sanitizer and `Element.setHTML()` are repository-level security admissions only. Even when admitted, ordinary components MUST receive a repository-approved safe rich-content domain object, not raw arbitrary HTML strings.

### 34.2 URL sinks

Rules:

1. Parse with `new URL(value, base)`.
2. Allow schemes explicitly.
3. Default navigation policy is same-origin relative or `https:`.
4. `javascript:` is forbidden.
5. `data:` is forbidden unless admitted for a narrow media case.
6. `blob:` requires ownership and revocation policy.
7. Do not infer URL safety from TypeScript `string`.
8. Navigation decisions MUST fail closed.

### 34.3 CSS sinks

Rules:

1. Do not assign untrusted values to `style.cssText`.
2. Do not create style rules from user data.
3. Do not assign raw user strings to CSS custom properties.
4. Validate scalar values before serializing to style properties or custom properties.
5. Prefer finite states over dynamic CSS values.
6. Never concatenate CSS source at runtime from untrusted input.

### 34.4 Script sinks

Forbidden:

1. `eval`.
2. `new Function`.
3. String timers.
4. Dynamic script text.
5. Dynamic script URLs.
6. Inline event handler attributes.

### 34.5 Dynamic tags

Rules:

1. Do not call `document.createElement(untrustedTag)`.
2. Dynamic tag creation uses an explicit allowlist.
3. Unknown tag strings are rejected before DOM creation.
4. Do not define custom elements from untrusted names.

### 34.6 DOM clobbering and globals

Rules:

1. Do not rely on global named properties.
2. Do not use global IDs for component internals.
3. Use captured shadow refs.
4. Do not access `window[id]`.
5. Do not use `document.forms[name]` for component internals.
6. Do not look up internal nodes from `document`.

### 34.7 External DOM and forged events

Rules:

1. External DOM references are boundary values.
2. Slotted DOM is external DOM.
3. Slotted custom elements are active external code, not inert markup.
4. External `CustomEvent.detail` is untrusted if consumed.
5. Validate event detail shape before using it.
6. If an external event is only a signal and detail is ignored, no detail validation is needed.
7. Do not store external DOM references beyond their validated lifetime.

### 34.8 Object URLs

Rules:

1. A component that creates an object URL owns its revocation.
2. Revoke object URLs on replacement and disconnect.
3. Do not revoke object URLs owned by callers.
4. Ownership transfer must be explicit.

## 35. Performance

Performance is structural.

Rules:

1. Parse CSS once per document per component.
2. Parse templates once per component module.
3. Clone/import static template once per instance.
4. Capture refs once per instance.
5. Do not query refs in render.
6. Do not create stylesheets per instance.
7. Do not repeatedly validate trusted typed values in hot paths.
8. Do not replace DOM subtrees by default.
9. Do not destroy focus, selection, scroll, or IME state.
10. Do not use MutationObserver as reactivity.
11. Do not create unbounded observers.
12. Do not read layout after writes in a loop.
13. Batch high-frequency DOM writes.
14. Prefer CSS for visual state.
15. Prefer native controls for built-in behavior.
16. Avoid avoidable allocation in hot paths.
17. Do not hide expensive work in getters.
18. Do not hide I/O in render or setters.
19. Do not perform support probing per instance.
20. Do not deep-clone trusted data in hot paths.
21. Do not deep-freeze trusted data in hot paths.
22. Do not allocate new listener functions during render.
23. Do not allocate event detail objects except when dispatching events.
24. Do not create unbounded microtask chains.
25. Do not repeatedly call `assignedNodes()` or `assignedElements()` in render; use `slotchange` when slot-derived behavior is needed.

Event listener dispatch rule:

1. Fixed internal controls MAY use direct listeners.
2. Dynamic repeated items SHOULD use delegation from an owned stable container.
3. External listeners are connection-scoped.
4. High-frequency listeners batch writes.

Layout rule:

1. Separate layout reads from layout writes.
2. Use `requestAnimationFrame` for measurement/write phases when layout is involved.
3. Do not use `requestAnimationFrame` for ordinary state updates that do not require frame alignment.

Microtask rule:

1. At most one render microtask may be queued per component instance.
2. A render microtask MUST NOT enqueue another render microtask unconditionally.
3. If render discovers more work, it must commit synchronously or schedule through an explicit bounded path.

## 36. Modern platform feature policy

Use modern platform features when they improve correctness, security, accessibility, performance, determinism, maintainability, or simplicity.

Admitted defaults:

1. ECMAScript private fields and methods.
2. Static class fields.
3. Shadow DOM.
4. Constructable stylesheets.
5. `adoptedStyleSheets`.
6. Abortable event listeners.
7. `ElementInternals` for forms, host accessibility, and custom states.
8. `CustomStateSet` / `:state()`.
9. Low-cost DSD-compatible shadow-root source shape.
10. CSS logical properties.
11. CSS custom properties.
12. CSS cascade layers.
13. CSS container queries.
14. Modern stable selectors when they improve clarity or correctness.
15. `inert` for modal or inactive subtrees when behavior requires it.

Repository-admission-only:

1. `moveBefore()` and `connectedMoveCallback()`.
2. HTML Sanitizer API.
3. `Element.setHTML()`.
4. Any platform feature whose behavior affects lifecycle, security, parsing, form behavior, focus, or DOM semantics and has not been admitted for the repository.

Rules:

1. Do not add per-component support checks.
2. Do not add unsupported-browser fallbacks.
3. Once a feature is admitted, use it directly.
4. If a feature is not admitted, do not use it in component source.
5. Do not chase novelty without a concrete improvement.
6. Do not avoid admitted modern features merely because they were not available in legacy browsers.

## 37. Error handling

Developer errors fail fast.

Developer errors include:

1. Missing required shadow refs.
2. Duplicate shadow refs.
3. Invalid static template structure.
4. Invalid present enum attribute.
5. Invalid present numeric attribute.
6. Duplicate registration.
7. Invalid public method call for current state.
8. Invalid component configuration.
9. Required slot missing when the slot contract requires it.
10. External event detail invalid when consumed.

User errors use UI, validity, or explicit error state.

User errors include:

1. Empty required form value.
2. Invalid user-entered form value.
3. Network failure in a component that explicitly owns loading.
4. Business validation failure.

Rules:

1. Do not log warnings as enforcement.
2. Do not silently recover from programmer mistakes.
3. Do not throw for normal user input invalidity.
4. Fail closed at security boundaries.
5. Own abort is normal cleanup.
6. Unknown async errors must surface through explicit state or caller-visible failure.

## 38. Forbidden patterns and replacements

Self-registration.

Replacement: exported `defineTch...()` called by application boundary.

Framework base class.

Replacement: direct `HTMLElement` subclass and narrow primitives.

Decorators.

Replacement: explicit static fields, setters, and define functions.

Reactive-property runtime.

Replacement: explicit private state, setters, and render methods.

Virtual DOM.

Replacement: static template and direct DOM patching.

Runtime HTML interpolation.

Replacement: static template plus `textContent` and DOM APIs.

Third-party runtime import.

Replacement: native platform capability or narrow owned primitive.

Generated style modules by default.

Replacement: `.scss?source`.

Per-instance stylesheet.

Replacement: per-document constructable stylesheet cache.

Global DOM constructors in ref checks.

Replacement: `ownerDocument.defaultView` constructors.

Per-document template cache.

Replacement: module-level static template and `ownerDocument.importNode(...)`.

Repeated `querySelector` in render.

Replacement: one-time typed ref capture.

MutationObserver reactivity.

Replacement: explicit state transitions.

Router/store imports.

Replacement: properties, methods, and DOM events.

Dependency-injection container.

Replacement: explicit application-boundary wiring outside generic components.

Runtime type assertions for trusted setters.

Replacement: strict TypeScript and validation before assignment.

Silent enum fallback.

Replacement: fail-fast invalid present serialized config.

`as any`.

Replacement: redesign the type boundary.

Non-null assertion.

Replacement: typed ref extraction or control-flow narrowing.

Dynamic URL assignment.

Replacement: URL parser and allowlist.

`div role="button"`.

Replacement: native `button`.

Positive `tabindex`.

Replacement: natural DOM order or valid roving tabindex.

## 39. Dispatch rules

Component or not:

If it needs element identity, lifecycle, Shadow DOM, slots, forms, focus, accessibility, or reusable DOM contract, use a Web Component. Otherwise use a normal TypeScript module.

Shadow or light DOM:

If it owns internal DOM or styles, use Shadow DOM. If it is only a semantic/progressive wrapper around consumer-owned content, light DOM MAY be used.

Property or attribute:

If typed runtime data, use a property. If serialized HTML configuration or CSS-selectable state, use an attribute.

Attribute invalidity:

Absent means default. Present invalid constrained serialized configuration fails fast unless the component explicitly owns hostile-boundary rejection.

Attribute, custom state, or private field:

If public and serialized, use an attribute. If CSS-visible but not serialized, use a custom state. If internal only, use a private field.

Template:

Static structure in a module-level static template. Dynamic text through `textContent`. Dynamic DOM through explicit DOM operations. Insert template content into the owner document with `ownerDocument.importNode(...)`.

Styles:

Always import SCSS through `.scss?source`. Always use constructable stylesheets. Always cache stylesheets per document. Styled components implement `adoptedCallback()`.

Refs:

Use `data-ref`. Require exactly one match. Use same-realm constructors. Capture once.

Render:

Patch known refs. Do not parse HTML. Do not query refs. Do not dispatch events.

Resources:

Owned internal listener may be instance lifetime. External listener, observer, timer, animation frame, and async work are connection- or operation-scoped.

Events:

Public component custom events are hyphen-only, exported as constants, dispatched from the host, and set `bubbles: true` and `composed: true`.

Validation:

Trusted TypeScript input is not revalidated. Hostile, serialized, external DOM, URL, HTML, CSS, script, storage, network, slotted-behavior, forged-event detail, and platform-erased values are validated.

Form controls:

Native-like form controls implement live value or live checked/selected state, default state, dirty state, reset, restore, submitted value, validity, and native-like `input`/`change` semantics.

Accessibility:

Choose one primary accessibility object per logical control: host-owned or internal-native-control. Do not expose competing accessible controls.

Modern features:

Admitted features are used directly. Unadmitted features are not used.

Dependencies:

Component modules do not import third-party runtime libraries. Use native platform capability or narrow owned primitives.

Public contract:

Public component contract surfaces change only deliberately and with all known internal callsites updated.

## 40. Final binding rule

The canonical component is a direct `HTMLElement` subclass named `Tch...Element`, with a `tch-...` tag constant, hyphen-only public event constants, explicit public event detail types when detail is present, no self-registration, no base class, no decorators, no runtime reactivity, no virtual DOM, no third-party runtime imports, SCSS imported as `.scss?source`, per-document constructable stylesheet caching, a module-level static template, open DSD-compatible Shadow DOM, same-realm exact-one typed ref extraction, private state, explicit attribute parsing, direct DOM patching, public custom events that bubble and compose, connection-scoped cleanup, stale async protection, native-like form value or checked-state semantics when applicable, a single primary accessibility object per logical control, native-first accessibility, strict label/form semantics, logical CSS, modern admitted CSS primitives, and controlled security sinks.

Any deviation MUST improve correctness, security, accessibility, performance, determinism, simplicity, or reviewability. If the improvement cannot be stated precisely, the deviation is rejected.

## 41. Source review rejection checklist

The doctrine body has authority. This checklist is an enforcement aid. If checklist and doctrine ever appear to conflict, apply the stricter doctrine-body rule and patch the checklist.

Reject component source if any item is true:

1. It does not extend `HTMLElement` directly.
2. It uses a base component class.
3. It uses decorators.
4. It uses a reactive-property runtime.
5. It uses virtual DOM.
6. It uses a runtime template DSL.
7. It uses `enum`, `const enum`, `namespace`, parameter properties, `as any`, or routine non-null assertions.
8. It self-registers.
9. It registers through import side effects.
10. Its define function omits the explicit registry parameter.
11. Its define function silently guards duplicate registration.
12. Its class name does not end in `Element`.
13. Its tag name does not start with `tch-`.
14. Its public custom event name is not hyphen-only.
15. Its public event lacks an exported event name constant.
16. Its public event has detail but lacks an exported detail type.
17. Its public custom event does not set `bubbles: true`.
18. Its public custom event does not set `composed: true`.
19. It augments `HTMLElementEventMap` for a component-specific custom event.
20. It uses public component events as a hidden event bus, service channel, request/response RPC mechanism, or implicit application-wide coordination layer.
21. It exports a factory function without a real construction invariant.
22. It imports a third-party runtime library inside a component module.
23. It imports component SCSS without `.scss?source`.
24. It creates a stylesheet per instance.
25. It uses a module-level constructed stylesheet.
26. It constructs a stylesheet with the wrong document realm.
27. It omits `adoptedCallback` for a styled component.
28. It uses generated style modules by default.
29. It uses runtime CSS-in-JS.
30. It uses a closed shadow root.
31. It unconditionally destroys or replaces an existing shadow root.
32. It appends template content without checking whether the root already has content.
33. It uses per-document template caching by default.
34. It does not import template content into `ownerDocument`.
35. It reads attributes in the constructor as source of component state.
36. It uses global DOM constructors in ref checks.
37. It accepts duplicate `data-ref` values.
38. It queries refs during render.
39. It uses dynamic `innerHTML`, `outerHTML`, `insertAdjacentHTML`, or `DOMParser`.
40. It uses `Element.setHTML()` or HTML Sanitizer APIs without repository security admission.
41. It replaces the shadow tree as a normal update.
42. It dispatches events from render.
43. It dispatches user-action events from programmatic setters.
44. Event detail exposes internal DOM or mutable internal objects.
45. It reads event detail from external custom events without validating it.
46. It ignores reentrancy after public or cancelable event dispatch.
47. It imports router, store, application service, dependency container, or global service locator code.
48. It performs network/storage I/O in setters or render.
49. It starts external listeners, observers, timers, animation frames, or async work without cleanup or abort.
50. It allows stale async state commits.
51. It allows stale async DOM commits.
52. It allows stale async event dispatch.
53. It runtime-validates trusted internal TypeScript property values merely defensively.
54. It fails to validate hostile, serialized, URL, HTML, CSS, script, storage, network, external-DOM, slotted-behavior, or forged-event boundaries.
55. It silently falls back for invalid present enum or numeric serialized configuration.
56. It mutates slotted DOM without an explicit slot contract.
57. It derives behavior from slotted DOM without validation.
58. It permits required slot absence without an explicit inert state.
59. It uses fallback slot content to mask a missing required accessible name.
60. It allows nested interactive slotted content inside an interactive component without a composite-widget contract.
61. It uses `MutationObserver` as reactivity.
62. It exposes internal classes, IDs, or DOM structure as public styling API.
63. It omits host display or hidden handling in SCSS.
64. It uses physical left/right CSS where logical properties are required.
65. It forces direction without public-contract justification.
66. It uses `:host-context()` for theming.
67. It creates an interactive control without native-first semantics.
68. It uses `div role="button"` when `button` works.
69. It lacks an accessible name for an interactive control.
70. It lacks keyboard behavior for an interactive control.
71. It uses positive `tabindex`.
72. It removes focus indicators without replacement.
73. It claims form-control behavior without form-associated `ElementInternals`.
74. It fails to define the native-like live/default/dirty model for a value-like, checked-state, or selected-state form control.
75. It dispatches `input` or `change` for programmatic value assignment.
76. It fails to reset live value or live checked/selected state to default state in `formResetCallback()`.
77. It fails to validate restored state in `formStateRestoreCallback()`.
78. It fails to synchronize submitted value before dispatching user value events.
79. It submits `FormData` without documenting the submitted entry names.
80. It mishandles external labels by targeting internal shadow IDs.
81. It creates competing host/internal accessible controls.
82. It has no declared host-owned or internal-native-control accessibility model for an interactive component.
83. It treats Shadow DOM or closed shadow as a security boundary.
84. It assigns unvalidated URLs to navigable or resource sinks.
85. It injects untrusted CSS or script strings.
86. It assigns raw user strings to CSS custom properties.
87. It dynamically creates tags from untrusted strings.
88. It creates object URLs without revocation ownership.
89. It relies on DOM clobbering-prone globals or global IDs.
90. It mutates caller-owned object input without explicit ownership transfer.
91. It creates unbounded microtask render chains.
92. It allocates listener functions during render.
93. It repeatedly calls `assignedNodes()` or `assignedElements()` during render for slot-derived behavior.
94. It logs warnings instead of enforcing source doctrine.
95. It introduces a helper that hides lifecycle, rendering, state, registration, routing, services, forms, events, attributes, or reactivity.
96. It changes a public component contract surface accidentally or without updating known internal callsites.
