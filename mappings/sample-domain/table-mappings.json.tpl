{
    "rules": [
        {
            "rule-type": "transformation",
            "rule-id": "131859668",
            "rule-name": "131859668",
            "rule-target": "schema",
            "object-locator": {
                "schema-name": "public"
            },
            "rule-action": "rename",
            "value": "fake",
            "old-value": null
        },
        {
            "rule-type": "selection",
            "rule-id": "516455654",
            "rule-name": "870343799",
            "object-locator": {
                "schema-name": "public",
                "table-name": "fake_preferences"
            },
            "rule-action": "include",
            "filters": []
        },
        {
            "rule-type": "transformation",
            "rule-id": "999999997",
            "rule-name": "999999997",
            "rule-action": "add-column",
            "rule-target": "column",
            "object-locator": {
                "schema-name": "%",
                "table-name": "%"
            },
            "value": "checkpoint_col",
            "expression": "$AR_H_CHANGE_SEQ",
            "data-type": {
                 "type": "string",
                 "length": 50
            }
        }
    ]
}