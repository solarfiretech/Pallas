import unittest

from app.settings import ConfigurationError, Settings


class SettingsTests(unittest.TestCase):
    def test_defaults_are_valid(self) -> None:
        settings = Settings.from_env({})
        self.assertEqual(settings.opcua_max_depth, 8)
        self.assertEqual(settings.postgres_healthcheck_port, 5432)
        self.assertEqual(settings.openplc_expected_http_statuses, frozenset({200, 404}))

    def test_rejects_malformed_numeric_value(self) -> None:
        with self.assertRaisesRegex(ConfigurationError, "OPCUA_MAX_DEPTH must be an integer"):
            Settings.from_env({"OPCUA_MAX_DEPTH": "deep"})

    def test_rejects_numeric_value_outside_range(self) -> None:
        with self.assertRaisesRegex(ConfigurationError, "POSTGRES_HEALTHCHECK_PORT must be between 1 and 65535"):
            Settings.from_env({"POSTGRES_HEALTHCHECK_PORT": "70000"})

    def test_rejects_depth_outside_range(self) -> None:
        with self.assertRaisesRegex(ConfigurationError, "OPCUA_MAX_DEPTH must be between 0 and 100"):
            Settings.from_env({"OPCUA_MAX_DEPTH": "101"})

    def test_rejects_malformed_timeout(self) -> None:
        with self.assertRaisesRegex(ConfigurationError, "HEALTHCHECK_TIMEOUT_SECONDS must be a number"):
            Settings.from_env({"HEALTHCHECK_TIMEOUT_SECONDS": "eventually"})

    def test_rejects_timeout_outside_range(self) -> None:
        with self.assertRaisesRegex(ConfigurationError, "OPCUA_TIMEOUT_SECONDS must be between 0.1 and 300"):
            Settings.from_env({"OPCUA_TIMEOUT_SECONDS": "0"})

    def test_rejects_empty_setting(self) -> None:
        with self.assertRaisesRegex(ConfigurationError, "OPCUA_BROWSE_ROOT must not be empty"):
            Settings.from_env({"OPCUA_BROWSE_ROOT": "  "})

    def test_rejects_malformed_expected_statuses(self) -> None:
        with self.assertRaisesRegex(ConfigurationError, "OPENPLC_EXPECTED_HTTP_STATUSES"):
            Settings.from_env({"OPENPLC_EXPECTED_HTTP_STATUSES": "200,banana"})

    def test_rejects_invalid_service_url(self) -> None:
        with self.assertRaisesRegex(ConfigurationError, "NODE_RED_HEALTHCHECK_URL"):
            Settings.from_env({"NODE_RED_HEALTHCHECK_URL": "node-red:1880"})

    def test_rejects_non_numeric_opcua_port(self) -> None:
        with self.assertRaisesRegex(ConfigurationError, "OPCUA_ENDPOINT_URL must have a numeric port"):
            Settings.from_env({"OPCUA_ENDPOINT_URL": "opc.tcp://openplc-runtime:not-a-port/path"})


if __name__ == "__main__":
    unittest.main()
