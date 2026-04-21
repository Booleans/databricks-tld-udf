import importlib.resources
import tempfile
import shutil


def get_suffix_list_path() -> str:
    """Returns a temp filesystem path to the bundled public suffix list."""
    ref = importlib.resources.files("tld_data").joinpath("data/public_suffix_list.dat")
    tmp = tempfile.mktemp(suffix=".dat")
    with importlib.resources.as_file(ref) as path:
        shutil.copy(str(path), tmp)
    return tmp
