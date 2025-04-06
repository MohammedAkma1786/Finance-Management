
# Finance Wisdom Garden

A modern personal finance management application built with React and TypeScript.

## Features

- Financial Dashboard with key metrics (income, expenses, savings)
- Transaction Management
- User Authentication
- Expense Planner
- Subscription Tracker
- Responsive Design

## Technologies

- React.js with TypeScript
- React Router for navigation
- Tailwind CSS for styling
- Shadcn UI component library
- Tanstack React Query
- Lucide React for icons

## Getting Started

1. Clone the repository
2. Install dependencies with `npm install`
3. Start the development server with `npm run dev`
4. Open http://localhost:8080 in your browser

## Docker Support

### Building and running with Docker

```bash
# Build the Docker image
docker build -t finance-wisdom-garden .

# Run the container
docker run -p 8080:80 finance-wisdom-garden
```

### Using Docker Compose

```bash
# Start the application
docker-compose up -d

# Stop the application
docker-compose down
```

To use Firebase with Docker, make sure to set up your environment variables:

```bash
# Example using a .env file
docker-compose --env-file .env up -d
```

## Project Structure

- `/src/components`: UI components
- `/src/pages`: Application pages
- `/src/contexts`: React context providers
- `/src/lib`: Utility functions
- `/src/hooks`: Custom React hooks
