#!/bin/bash

echo "Generating load on e-commerce application..."

INGRESS_URL=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

if [ -z "$INGRESS_URL" ]; then
    INGRESS_URL=$(kubectl get svc -n ingress-nginx ingress-nginx-controller -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
fi

echo "Target: http://$INGRESS_URL"

for i in {1..1000}; do
    curl -s http://$INGRESS_URL/api/products > /dev/null &
    
    if [ $((i % 10)) -eq 0 ]; then
        curl -s -X POST http://$INGRESS_URL/api/products \
          -H "Content-Type: application/json" \
          -d "{\"name\":\"Product $i\",\"price\":$((RANDOM % 1000)).99,\"stock\":$((RANDOM % 100)),\"category\":\"Test\"}" > /dev/null &
    fi
    
    if [ $((i % 100)) -eq 0 ]; then
        echo "Sent $i requests..."
    fi
    
    sleep 0.01
done

wait

echo "Load test complete! Check Grafana dashboards."
