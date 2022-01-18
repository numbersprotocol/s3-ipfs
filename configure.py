#!/usr/bin/env python

import argparse
import json
import os
from typing import Dict


def create_datastore_spec(bucket: str, region: str) -> Dict:
    return {
        'mounts': [
            {
                'bucket': bucket,
                'mountpoint': '/blocks',
                'region': region,
                'rootDirectory': '/blocks',
            },
            {
                'mountpoint': '/',
                'path': 'datastore',
                'type': 'levelds',
            }
        ],
        'type': 'mount',
    }


def update_config(config: Dict, bucket: str, region: str, region_endpoint: str):
    config['Datastore']['Spec']['mounts'][0] = {
        'child': {
            'type': 's3ds',
            'region': region,
            'bucket': bucket,
            'rootDirectory': '/blocks',
            'regionEndpoint': region_endpoint,
            'accessKey': '',
            'secretKey': '',
        },
        'mountpoint': '/blocks',
        'prefix': 's3.datastore',
        'type': 'measure',
    }



def get_config_path(base_dir: str):
    return os.path.join(os.path.expanduser(base_dir), 'config')


def get_datastore_spec_path(base_dir: str):
    return os.path.join(os.path.expanduser(base_dir), 'datastore_spec')


def load_config(base_dir: str) -> Dict:
    config_path = get_config_path(base_dir)
    print(config_path)
    with open(config_path) as f:
        return json.load(f)


def save_config(base_dir: str, config: Dict) -> Dict:
    config_path = get_config_path(base_dir)
    with open(config_path, 'w') as f:
        json.dump(config, f, indent=4)


def save_datastore_spec(base_dir: str, datastore_spec: Dict) -> Dict:
    datastore_spec_path = get_datastore_spec_path(base_dir)
    with open(datastore_spec_path, 'w') as f:
        json.dump(datastore_spec, f, separators=(',', ':'))


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '--base-dir', default='~/.ipfs',
        help='IPFS config dir. Defaults to ~/.ipfs'
    )
    parser.add_argument(
        '--region', default='us-east-1',
        help='AWS region for S3 bucket',
    )
    parser.add_argument(
        '--bucket', required=True,
        help='AWS S3 bucket name',
    )
    parser.add_argument(
        '--region-endpoint',
        help='AWS S3 region endpoint (for S3 compatible provider or acceleration)',
    )
    args = parser.parse_args()

    config = load_config(args.base_dir)
    update_config(
        config,
        args.bucket,
        args.region,
        args.region_endpoint,
    )
    save_config(args.base_dir, config)

    datastore_spec = create_datastore_spec(args.bucket, args.region)
    save_datastore_spec(args.base_dir, datastore_spec)


if __name__ == '__main__':
    main()
