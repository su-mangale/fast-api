# AWS Credentials Configuration

This guide explains how to configure AWS credentials for Terraform deployment.

## Option 1: AWS CLI Configuration (Recommended)

### Install AWS CLI
```bash
# On Ubuntu/Debian
sudo apt-get install awscli

# On MacOS
brew install awscli

# On Windows
# Download from: https://aws.amazon.com/cli/
```

### Configure AWS CLI
```bash
aws configure
```

You'll be prompted for:
- **AWS Access Key ID**: Your IAM user access key
- **AWS Secret Access Key**: Your IAM user secret key  
- **Default region name**: e.g., `us-east-1`
- **Default output format**: `json` (recommended)

### Verify Configuration
```bash
aws sts get-caller-identity
```

This should return your AWS account details.

## Option 2: Environment Variables

Set these environment variables in your shell:

```bash
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
export AWS_DEFAULT_REGION="us-east-1"
```

### Make it Persistent
Add to your shell profile (`.bashrc`, `.zshrc`, etc.):

```bash
echo 'export AWS_ACCESS_KEY_ID="your-access-key-id"' >> ~/.bashrc
echo 'export AWS_SECRET_ACCESS_KEY="your-secret-access-key"' >> ~/.bashrc
echo 'export AWS_DEFAULT_REGION="us-east-1"' >> ~/.bashrc
source ~/.bashrc
```

## Option 3: IAM Roles (For EC2/Lambda)

If running Terraform from an EC2 instance or Lambda:

1. Create an IAM role with necessary permissions
2. Attach the role to your EC2 instance
3. No additional configuration needed

## Option 4: AWS SSO (Single Sign-On)

If your organization uses AWS SSO:

```bash
aws configure sso
aws sso login --profile your-profile-name
export AWS_PROFILE=your-profile-name
```

## Required IAM Permissions

Your AWS user/role needs these permissions:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:*",
        "iam:PassRole",
        "iam:GetRole"
      ],
      "Resource": "*"
    }
  ]
}
```

### Creating IAM User (Step by Step)

1. **Go to AWS Console** → IAM → Users → Add User
2. **Username**: `terraform-user`
3. **Access Type**: ✅ Programmatic access
4. **Permissions**: 
   - Attach existing policies directly
   - Search and select: `AmazonEC2FullAccess`
5. **Review and Create**
6. **Download** the Access Key ID and Secret Access Key

## Security Best Practices

### 1. Use Least Privilege
Only grant necessary permissions:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ec2:RunInstances",
        "ec2:TerminateInstances",
        "ec2:DescribeInstances",
        "ec2:DescribeImages",
        "ec2:DescribeVpcs",
        "ec2:DescribeSubnets",
        "ec2:DescribeSecurityGroups",
        "ec2:CreateSecurityGroup",
        "ec2:DeleteSecurityGroup",
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:AuthorizeSecurityGroupEgress",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:RevokeSecurityGroupEgress",
        "ec2:DescribeKeyPairs",
        "ec2:CreateTags",
        "ec2:DescribeTags"
      ],
      "Resource": "*"
    }
  ]
}
```

### 2. Rotate Keys Regularly
- Set up key rotation schedule
- Use AWS Secrets Manager for sensitive data

### 3. Never Commit Credentials
- Add AWS credential files to `.gitignore`
- Use environment variables or AWS CLI profiles
- Never hardcode credentials in Terraform files

## Terraform AWS Provider Configuration

The provider is already configured in `main.tf`:

```hcl
provider "aws" {
  region = var.aws_region
  # Credentials automatically detected from:
  # 1. Environment variables
  # 2. AWS CLI profile
  # 3. IAM roles
  # 4. Instance metadata
}
```

## Testing Your Configuration

```bash
# Test AWS CLI access
aws sts get-caller-identity

# Test Terraform access
cd terraform
terraform init
terraform plan
```

## Troubleshooting

### Common Issues

1. **"Unable to locate credentials"**
   - Run `aws configure` to set up credentials
   - Or set environment variables

2. **"Access Denied"**
   - Check IAM permissions
   - Verify user has EC2 access

3. **"Invalid region"**
   - Check region name in terraform.tfvars
   - Verify region exists and is enabled

### Debug Commands

```bash
# Check current AWS identity
aws sts get-caller-identity

# List available regions
aws ec2 describe-regions --output table

# Check configured profile
aws configure list

# Test EC2 permissions
aws ec2 describe-instances --region us-east-1
```

## Alternative: AWS Vault

For enhanced security, consider using AWS Vault:

```bash
# Install AWS Vault
brew install aws-vault  # macOS
# or download from GitHub

# Add profile
aws-vault add terraform

# Use with Terraform
aws-vault exec terraform -- terraform plan
```

This encrypts credentials and provides temporary session tokens.
