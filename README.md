# iOS-Ecommerce-Assignment
Foy For You Assignment

This is a simple iOS e-commerce app built as an assignment to demonstrate clean architecture, cart handling, pagination, and basic checkout flow.
The focus of this project is clarity, correctness, and real-world behavior, not fancy UI or unnecessary abstractions.

## Features

Product listing with brand-based sections
Pagination with safe handling of duplicate products
Product detail screen with:
Add to Cart
Quantity stepper
Stock handling
Cart screen with:
Item quantity update
Swipe to delete
Automatic empty state
Cart badge update across the app
Offer / scratch card support
Simple checkout flow using a dummy payment service

### App Flow (High Level)

1) Product List
Products are grouped by brand (Apple, Samsung, Google, Sony, etc.)
Data is loaded page by page
Cart icon shows total item count

2) Product Detail
User can add a product to cart
Quantity stepper appears once item is added
If quantity goes back to 0, Add to Cart button reappears
Cart icon in the top right always stays in sync

3) Cart
User can increase / decrease quantity
Quantity 0 removes the item automatically
Swipe to delete is supported
Empty cart shows a proper empty state
Summary updates instantly (subtotal, discount, total)

### Architecture

The app follows a simple MVVM structure:
ViewControllers only handle UI and user interaction
ViewModels contain business logic
Services handle data fetching and cart logic
NotificationCenter is used to sync cart updates across screens
This keeps the app easy to understand and easy to extend.

### Cart Handling

Cart is managed using a single CartService
All screens read cart state from the same source
When cart updates:

1) Product Detail updates its stepper state
2) Product List updates the cart badge
3) Cart screen refreshes automatically

### Mock Data & Networking

Product data is fetched using a GraphQL-style
Responses are mocked using local JSON files
This makes the app testable and independent of a real backend


## Payment

Checkout uses a dummy payment service
No real transactions are performed
Flow is designed to show how payment integration would work


### Key Principles
- No business logic inside ViewControllers
- ViewModels coordinate data flow only
- Services encapsulate business rules
- Protocol-driven design for flexibility and testability
- Session-based persistence (no database)

## Summary

This project demonstrates:
- Senior-level architectural thinking
- Clean separation of concerns
- Scalable and testable business logic

The application is fully functional and can easily be extended with real APIs, authentication, persistence, or payment gateways.
