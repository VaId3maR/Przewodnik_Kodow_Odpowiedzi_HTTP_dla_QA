#!/bin/bash

# =========================
# Konfiguracja
# =========================
BASE_URL="https://example.com" # <--- ZMIEŃ ADRES APLIKACJI NA SWÓJ
OUTPUT_FILE="curl_test_report.txt" # <--- MOŻNA ZMIENIĆ NAZWĘ PLIKU DO ZAPISU RAPORTU
echo "=== CURL HTTP CODE TEST REPORT ===" > "$OUTPUT_FILE"
echo "Test wykonany: $(date '+%Y-%m-%d %H:%M:%S')" >> "$OUTPUT_FILE"
echo "Adres bazowy: $BASE_URL" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# =========================
# Funkcja pomocnicza
# =========================
run_test() {
  local description="$1"
  local curl_command="$2"
  local expected_code="$3"
  local timestamp=$(date "+%H:%M")
  
  # Wykonaj curl i pobierz tylko kod odpowiedzi
  http_code=$(eval "$curl_command -o /dev/null -s -w \"%{http_code}\"")
  
  if [ "$http_code" == "$expected_code" ]; then
    status="PASSED"
  else
    status="FAILED (got $http_code)"
  fi

  # Logowanie wyniku do pliku
  echo "[$timestamp] $description — $status" >> "$OUTPUT_FILE"
}

# =========================
# Testy HTTP
# =========================

# W TESTACH NALEŻY ZMIENIĆ ŚCIEŻKI DO ENDPOINTÓW

run_test "200 OK – Strona główna działa" \
         "curl -I $BASE_URL" \
         "200"

run_test "201 Created – Tworzenie zasobu (POST)" \
         "curl -X POST $BASE_URL/api/resource -d '{\"name\":\"test\"}' -H \"Content-Type: application/json\"" \
         "201"

run_test "204 No Content – Usuwanie zasobu (DELETE)" \
         "curl -X DELETE $BASE_URL/api/resource/123" \
         "204"

run_test "400 Bad Request – Nieprawidłowe dane wejściowe" \
         "curl -X POST $BASE_URL/api/resource -d 'niepoprawne_dane'" \
         "400"

run_test "401 Unauthorized – Brak autoryzacji" \
         "curl $BASE_URL/secure/data" \
         "401"

run_test "403 Forbidden – Brak dostępu pomimo autoryzacji" \
         "curl -H \"Authorization: Bearer FAKE_TOKEN\" $BASE_URL/admin" \
         "403"

run_test "404 Not Found – Zasób nie istnieje" \
         "curl $BASE_URL/nieistniejacy-zasob" \
         "404"

run_test "409 Conflict – Duplikat zasobu" \
         "curl -X POST $BASE_URL/api/users -d '{\"email\":\"istniejacy@email.com\"}' -H \"Content-Type: application/json\"" \
         "409"

run_test "500 Internal Server Error – Błąd serwera" \
         "curl $BASE_URL/test-error" \
         "500"

run_test "502 Bad Gateway – Brak połączenia z backendem" \
         "curl $BASE_URL/serwis-przez-proxy" \
         "502"

run_test "503 Service Unavailable – Tryb konserwacji" \
         "curl $BASE_URL/maintenance" \
         "503"

run_test "504 Gateway Timeout – Backend nie odpowiada" \
         "curl --max-time 2 $BASE_URL/wolny-endpoint" \
         "504"

# =========================
# Zakończenie
# =========================
echo "" >> "$OUTPUT_FILE"
echo "Test zakończony o $(date '+%H:%M:%S')" >> "$OUTPUT_FILE"
echo "Wyniki zapisane w pliku: $OUTPUT_FILE"