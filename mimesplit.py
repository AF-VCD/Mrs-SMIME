#!/usr/bin/python3
"""Unpacks a MIME message into a directory of files."""

import os
import email
import mimetypes
import re
from email.policy import default
from sys import stdin
from argparse import ArgumentParser, FileType


def main():
    parser = ArgumentParser(description="""\
Unpack a MIME message into a directory of files.
""")
    parser.add_argument('-d', '--directory', required=True,
                        help="""Unpack the MIME message into the named
                        directory, which will be created if it doesn't already
                        exist.""")
    parser.add_argument('msgfile')
    args = parser.parse_args()

    with open(args.msgfile, 'rb') as fp:
        msg = email.message_from_binary_file(fp, policy=default)

    try:
        os.mkdir(args.directory)
    except FileExistsError:
        pass

    counter = 1
    for part in msg.walk():
        # multipart/* are just containers
        if part.get_content_maintype() == 'multipart':
            continue
        filename = part.get_filename()
        mime_type = part.get_content_type()
        print(f'Part {counter}: ')
        print(f'\tMIME Type: {str(mime_type)}')
        print(f'\tDetected Name: {str(filename)}')
        # Most attachments will have file names, but the text and html versions of the email body will not.
        if not filename:
            # directly specifying txt and html because the guess_extension function
            #  didn't work very well for those types
            if mime_type == 'text/plain':
                ext = '.txt'
            elif mime_type == 'text/html':
                ext = '.html'
            else:
                ext = mimetypes.guess_extension(mime_type, strict=False)
                if not ext:
                    # Use a generic bag-of-bits extension
                    ext = '.bin'
            
            filename = f'part-{counter:03d}{ext}'
        print(f'\tOutput Name: {str(filename)}')
        counter += 1
        with open(os.path.join(args.directory, filename), 'wb') as fp:
            fp.write(part.get_payload(decode=True))


if __name__ == '__main__':
    main()