from pathlib import Path
import subprocess
import unittest


ROOT = Path(__file__).resolve().parents[2]


class SecureCredentialContractTests(unittest.TestCase):
    def test_example_has_only_nonfunctional_secret_file_placeholders(self) -> None:
        example = (ROOT / ".env.example").read_text(encoding="utf-8")
        self.assertNotIn("change-me", example)
        self.assertNotIn("POSTGRES_PASSWORD=", example)
        self.assertNotIn("PGADMIN_DEFAULT_PASSWORD=", example)
        self.assertIn("REPLACE_WITH_POSTGRES_PASSWORD_FILE", example)
        self.assertIn("REPLACE_WITH_PGADMIN_PASSWORD_FILE", example)

    def test_passwords_are_runtime_secrets_not_service_environment(self) -> None:
        compose = (ROOT / "docker-compose.yml").read_text(encoding="utf-8")
        self.assertIn("POSTGRES_PASSWORD_FILE: /run/secrets/postgres_password", compose)
        self.assertIn("PGADMIN_DEFAULT_PASSWORD_FILE: /run/secrets/pgadmin_password", compose)
        self.assertNotIn("DATABASE_URL:", compose)
        self.assertNotIn("${POSTGRES_PASSWORD:", compose)

    def test_local_secret_locations_are_ignored(self) -> None:
        for path in (".env", ".secrets/postgres_password"):
            with self.subTest(path=path):
                result = subprocess.run(
                    ["git", "check-ignore", "-q", path], cwd=ROOT, check=False
                )
                self.assertEqual(result.returncode, 0)


if __name__ == "__main__":
    unittest.main()
