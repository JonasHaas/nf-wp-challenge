# nf-wp-challenge

### Pre-Requirements:
- Create S3-Bucket with a unique-name and replace it in the variables.tf in the root folder (search for @replace)


## Task 1

Create a Terraform script with the following components

- [x] vpc
- [x] Public & private subnets
- [x] Internet gateway
- [x] Nat gateway
- [x] Security groups (http, SSH)
- [x] Public & Private routing tables

Optional:

- [x] Enable Tracing (Logs)
- [x] Create a file to keep the variables
- [x] Naming conventions
- [x] Best practices
- [x] Store state-file in s3


## Task 2

Add Wordpress to your Setup

- [ ] Create a wordpress server
- [ ] Create a example blog page
- [ ] Present the website

## Task 3

Migrate Wordpress local db to RDS

## Task 4

Autoscaling and Loadbalancing
