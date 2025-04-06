# Finance Wisdom Garden Architecture

## Overview

The Finance Wisdom Garden application uses a modern serverless architecture, leveraging cloud services to minimize operational overhead while maximizing scalability and reliability.

## Architecture Components

### Frontend

- **React.js**: Single-page application built with React and TypeScript
- **Tailwind CSS**: For responsive UI design
- **React Router**: For client-side routing

### Backend Services

- **Firebase Authentication**: Handles user authentication
- **Firebase Firestore**: NoSQL database for storing user data
- **Firebase Storage**: For storing user files and images

### DevOps

- **GitHub Actions**: CI/CD pipeline for automated testing and deployment
- **Docker**: Containerization for consistent environments
- **Terraform**: Infrastructure as Code to provision AWS resources

### AWS Infrastructure

- **ECR (Elastic Container Registry)**: Stores Docker images
- **ECS (Elastic Container Service)**: Runs containerized applications
- **Fargate**: Serverless compute engine for containers
- **Application Load Balancer**: Routes traffic to the application
- **CloudWatch**: Monitoring and logging

## Data Flow

1. Users interact with the React frontend
2. Authentication requests are sent to Firebase Auth
3. Data operations are performed against Firebase Firestore
4. The application is deployed via GitHub Actions to AWS ECS
5. Monitoring and logging data is collected in CloudWatch

## Deployment Process

1. Code is pushed to the GitHub repository
2. GitHub Actions workflow is triggered
3. Application is built and tested
4. Docker image is created and pushed to DockerHub
5. Terraform provisions or updates AWS infrastructure
6. New version of the application is deployed to ECS

## Security Considerations

- Firebase authentication for user identity
- HTTPS for all communication
- Environment variables for sensitive configuration
- IAM roles for AWS resource access
- Security groups to restrict network access
