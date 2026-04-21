# tld_data — Databricks UDF Package

Bundles a `public_suffix_list.dat` file into a Python wheel so it can be
used inside a Databricks Unity Catalog Python UDF (which cannot access
Volume paths at runtime directly).

## Setup

### 1. Add the suffix list

Replace `tld_data/data/public_suffix_list.dat` with the real list:

```bash
curl -o tld_data/data/public_suffix_list.dat \
  https://publicsuffix.org/list/public_suffix_list.dat
```

### 2. Build the wheel

```bash
pip install build
python -m build --wheel
# Output: dist/tld_data-1.0.0-py3-none-any.whl
```

### 3. Upload to Databricks Volume

```bash
databricks fs cp dist/tld_data-1.0.0-py3-none-any.whl \
  dbfs:/Volumes/shared/tmp_public_suffix/wheels/tld_data-1.0.0-py3-none-any.whl
```

### 4. Create the UDF

Run `udf_tld_extract.sql` in Databricks SQL or a notebook.

## Usage

```sql
SELECT shared.tmp_public_suffix.tld_extract('blog.example.co.uk');
-- Returns: { subdomain: "blog", domain: "example", suffix: "co.uk", ... }
```
