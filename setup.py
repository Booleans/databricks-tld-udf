from setuptools import setup, find_packages

setup(
    name="tld_data",
    version="1.0.0",
    packages=find_packages(),
    package_data={
        "tld_data": ["data/public_suffix_list.dat"],
    },
    include_package_data=True,
    python_requires=">=3.8",
)
