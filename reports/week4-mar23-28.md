# Week 4 Report: March 23 - March 28, 2026

## Focus: IDS/IPS & Log Monitoring

### Tests Performed
- SQL injection attempts against test web server
- Directory traversal attacks
- XSS payload injection

### Issues Encountered
- Snort generated many false positives
- Wazuh indexer consuming too much RAM (8GB allocated)

### Solutions Implemented
- Configured Snort in low-memory mode (`engine_profile = detect`)
- Reduced OpenSearch heap size from 4GB to 2GB
- Implemented log rotation for Snort alerts (daily, 30-day retention)

### Status
✅ Snort now uses ~300MB RAM. False positives reduced.

### Snort Low-Memory Configuration

detection = {
    engine_profile = "detect",
    search_engine = {
        hyperscan = {
            enabled = false
        }
    }
}
