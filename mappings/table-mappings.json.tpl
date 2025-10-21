{
    "rules": [
        {
            "rule-type": "selection",
            "rule-id": "516450001",
            "rule-name": "nomis.offender_ppty_containers",
            "object-locator": {
                "schema-name": "OMS_OWNER",
                "table-name": "OFFENDER_PPTY_CONTAINERS"
            },
            "rule-action": "include",
            "filters": []
        },
        {
            "rule-type": "selection",
            "rule-id": "516450002",
            "rule-name": "nomis.offender_identifiers",
            "object-locator": {
                "schema-name": "OMS_OWNER",
                "table-name": "OFFENDER_IDENTIFIERS"
            },
            "rule-action": "include",
            "filters": []
        },
        {
            "rule-type": "selection",
            "rule-id": "516450003",
            "rule-name": "nomis.offender_release_details",
            "object-locator": {
                "schema-name": "OMS_OWNER",
                "table-name": "OFFENDER_RELEASE_DETAILS"
            },
            "rule-action": "include",
            "filters": []
        },
        {
            "rule-type": "selection",
            "rule-id": "516450004",
            "rule-name": "nomis.offenders",
            "object-locator": {
                "schema-name": "OMS_OWNER",
                "table-name": "OFFENDERS"
            },
            "rule-action": "include",
            "filters": []
        },
        {
            "rule-type": "selection",
            "rule-id": "516450005",
            "rule-name": "nomis.offender_bookings",
            "object-locator": {
                "schema-name": "OMS_OWNER",
                "table-name": "OFFENDER_BOOKINGS"
            },
            "rule-action": "include",
            "filters": []
        },
        {
            "rule-type": "selection",
            "rule-id": "516450006",
            "rule-name": "nomis.offender_languages",
            "object-locator": {
                "schema-name": "OMS_OWNER",
                "table-name": "OFFENDER_LANGUAGES"
            },
            "rule-action": "include",
            "filters": []
        },
        {
            "rule-type": "selection",
            "rule-id": "516450008",
            "rule-name": "nomis.offender_iep_levels",
            "object-locator": {
                "schema-name": "OMS_OWNER",
                "table-name": "OFFENDER_IEP_LEVELS"
            },
            "rule-action": "include",
            "filters": []
        },
        {
            "rule-type": "selection",
            "rule-id": "516450009",
            "rule-name": "nomis.offender_ppty_con_txns",
            "object-locator": {
                "schema-name": "OMS_OWNER",
                "table-name": "OFFENDER_PPTY_CON_TXNS"
            },
            "rule-action": "include",
            "filters": []
        },
        {
            "rule-type": "selection",
            "rule-id": "516450010",
            "rule-name": "nomis.offender_curfews",
            "object-locator": {
                "schema-name": "OMS_OWNER",
                "table-name": "OFFENDER_CURFEWS"
            },
            "rule-action": "include",
            "filters": []
        },
        {
            "rule-type": "selection",
            "rule-id": "516450012",
            "rule-name": "nomis.bed_assignment_histories",
            "object-locator": {
                "schema-name": "OMS_OWNER",
                "table-name": "BED_ASSIGNMENT_HISTORIES"
            },
            "rule-action": "include",
            "filters": []
        },
        {
            "rule-type": "selection",
            "rule-id": "516450013",
            "rule-name": "nomis.offender_military_records",
            "object-locator": {
                "schema-name": "OMS_OWNER",
                "table-name": "OFFENDER_MILITARY_RECORDS"
            },
            "rule-action": "include",
            "filters": []
        },


        {
            "rule-type": "transformation",
            "rule-id": "870343803",
            "rule-name": "870343803",
            "rule-action": "convert-lowercase",
            "rule-target": "table",
            "object-locator": {
                "schema-name": "%",
                "table-name": "%"
            }
        },
        {
            "rule-type": "transformation",
            "rule-id": "870343804",
            "rule-name": "870343804",
            "rule-action": "rename",
            "rule-target": "schema",
            "object-locator": {
                "schema-name": "${input_schema}"
            },
            "value": "${output_space}"
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
