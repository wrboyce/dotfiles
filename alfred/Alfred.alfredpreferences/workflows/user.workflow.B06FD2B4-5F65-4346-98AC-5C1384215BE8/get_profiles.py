import os
import json

import biplist


def get_profiles(query):
    # Read iTerm preferences file
    iTermPreferencesPath = os.path.join(
            os.environ["HOME"],
            "Library", "Preferences", "com.googlecode.iterm2.plist")
    plist = biplist.readPlist(iTermPreferencesPath)

    # Extract profile data from plist
    profiles = {}
    for nb in plist['New Bookmarks']:
        profiles[nb.get('Name')] = {
            'name': nb.get('Name'),
            'command': nb.get('Command'),
            'tags': nb.get('Tags')
        }

    # Filter profile names by query (if provided)
    if len(query) > 0:
        profiles = {name: data for name, data
                in profiles.iteritems() if query.lower() in name.lower()}

    # Generate json output for Alfred
    items = [{
            'uuid': name,
            'title': name,
            'subtitle': data['command'],
            'arg': name,
        } for name, data in sorted(profiles.iteritems())]
    return dict(items=items)


if __name__ == '__main__':
    import sys

    profiles = get_profiles(' '.join(sys.argv[1:]))
    print(json.dumps(profiles))
