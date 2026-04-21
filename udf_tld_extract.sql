-- Step 1: Build the wheel locally:
--   cd tld_data_package/
--   pip install build
--   python -m build --wheel
--
-- Step 2: Upload the wheel to your Databricks Volume:
--   databricks fs cp dist/tld_data-1.0.0-py3-none-any.whl \
--     dbfs:/Volumes/shared/tmp_public_suffix/wheels/tld_data-1.0.0-py3-none-any.whl
--
-- Step 3: Run this SQL in Databricks to create the UDF.

CREATE OR REPLACE FUNCTION shared.tmp_public_suffix.tld_extract(hostname STRING)
RETURNS STRUCT<
  subdomain STRING,
  domain STRING,
  suffix STRING,
  is_private BOOLEAN,
  registry_suffix STRING
>
LANGUAGE PYTHON
ENVIRONMENT (
  dependencies = '[
    "tldextract==5.3.1",
    "/Volumes/shared/tmp_public_suffix/wheels/tld_data-1.0.0-py3-none-any.whl"
  ]',
  environment_version = 'None'
)
AS $$
import tldextract
import tld_data

# Module-level initialization — runs once per worker, not per row
_suffix_list_path = tld_data.get_suffix_list_path()
_extractor = tldextract.TLDExtract(
    suffix_list_urls=[f"file://{_suffix_list_path}"],
    cache_dir=None,
    fallback_to_snapshot=False,
    include_psl_private_domains=True,
)

def tld_extract(hostname):
    if hostname:
        return _extractor(hostname)
    return None
$$;
