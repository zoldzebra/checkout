# Checkout System

A modular and extensible checkout system built with Elixir, designed to handle various pricing strategies.

## Project Overview

This checkout system processes a list of product codes and calculates the total price based on configurable pricing rules. The system is designed with modularity and extensibility as core principles, making it easy to add new products and pricing strategies.

## Key Features

- **Modular Architecture**: Clear separation of concerns across multiple modules
- **Extensible Pricing Strategies**: Easy to add new pricing rules without modifying existing code
- **Decimal Calculations**: Uses the Decimal library for accurate monetary calculations
- **Configurable Product Rules**: Products and their pricing rules are defined in a central configuration

## Project Structure

The project is organized into three main modules:

1. **Checkout**: The main entry point that orchestrates the checkout process

   - Filters valid products
   - Calculates the total price
   - Returns the final amount as a float with 2 decimal places

2. **ProductConfig**: Manages product configuration

   - Defines base prices for products
   - Specifies which pricing strategy applies to each product
   - Provides helper functions to access product information

3. **PricingStrategy**: Implements various pricing strategies
   - Buy-one-get-one-free
   - Bulk discounts (fixed price or percentage-based)
   - Default pricing
   - All calculations use Decimal for precision

## Extending the System

Adding new pricing strategies is straightforward:

1. Add a new function clause to `PricingStrategy.calculate/4` with the new strategy
2. Update the product configuration in `ProductConfig.all/0` to use the new strategy
3. No changes needed to the core checkout logic
