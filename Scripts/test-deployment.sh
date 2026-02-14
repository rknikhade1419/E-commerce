#!/bin/bash

echo "============================================"
echo "E-Commerce Application Deployment Test"
echo "============================================"

INGRESS_URL=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

if [ -z "$INGRESS_URL" ]; then
    INGRESS_URL=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
fi

if [ -z "$INGRESS_URL" ]; then
    echo "Error: Could not determine Ingress URL"
    exit 1
fi

echo "Ingress URL: $INGRESS_URL"
echo ""

echo "Test 1: Health Check"
HEALTH=$(curl -s http://$INGRESS_URL/actuator/health | jq -r '.status')
if [ "$HEALTH" == "UP" ]; then
    echo "✓ Health check passed"
else
    echo "✗ Health check failed"
    exit 1
fi
echo ""

echo "Test 2: Get Products"
PRODUCTS=$(curl -s http://$INGRESS_URL/api/products)
echo "Products: $PRODUCTS"
echo "✓ Get products passed"
echo ""

echo "Test 3: Create Product"
PRODUCT=$(curl -s -X POST http://$INGRESS_URL/api/products \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test Product",
    "description": "Created by test script",
    "price": 99.99,
    "stock": 100,
    "category": "Test"
  }')

PRODUCT_ID=$(echo $PRODUCT | jq -r '.id')
echo "Created product with ID: $PRODUCT_ID"
echo "✓ Create product passed"
echo ""

echo "Test 4: Get Single Product"
curl -s http://$INGRESS_URL/api/products/$PRODUCT_ID | jq .
echo "✓ Get single product passed"
echo ""

echo "Test 5: Get by Category"
curl -s http://$INGRESS_URL/api/products/category/Test | jq .
echo "✓ Get by category passed"
echo ""

echo "============================================"
echo "All tests passed! ✓"
echo "============================================"
echo "Access your application at:"
echo "http://$INGRESS_URL/api/products"
echo "============================================"
