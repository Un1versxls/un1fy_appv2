#!/usr/bin/env python3
import re
from pathlib import Path

PROJECT_DIR = Path(__file__).parent
PBXPROJ_PATH = PROJECT_DIR / "DRIVE.xcodeproj" / "project.pbxproj"
SOURCE_DIR = PROJECT_DIR / "DRIVE"

SERVICES_DIR = SOURCE_DIR / "Services"
MODELS_DIR = SOURCE_DIR / "Models"
VIEWMODELS_DIR = SOURCE_DIR / "ViewModels"
VIEWS_DIR = SOURCE_DIR / "Views"
COMPONENTS_DIR = SOURCE_DIR / "Components"

def get_swift_files():
    swift_files = []
    dirs = [SERVICES_DIR, MODELS_DIR, VIEWMODELS_DIR, VIEWS_DIR, COMPONENTS_DIR]
    for d in dirs:
        if d.exists():
            for f in d.glob("*.swift"):
                swift_files.append(f.name)
    return swift_files

def update_pbxproj():
    if not PBXPROJ_PATH.exists():
        print(f"Error: {PBXPROJ_PATH} not found")
        return False
    
    content = PBXPROJ_PATH.read_text(encoding='utf-8')
    
    swift_files = get_swift_files()
    if not swift_files:
        print("No Swift files found")
        return True
    
    existing_files = set(re.findall(r'/\* (\S+\.swift) \*/', content))
    
    new_files = [f for f in swift_files if f not in existing_files]
    if not new_files:
        print("All Swift files already in project")
        return True
    
    print(f"Adding new files: {new_files}")
    
    max_ref = 0
    for match in re.finditer(r'A200000(\d+)', content):
        max_ref = max(max_ref, int(match.group(1)))
    
    max_build = 0
    for match in re.finditer(r'A100000(\d+)', content):
        max_build = max(max_build, int(match.group(1)))
    
    max_group = 0
    for match in re.finditer(r'A500000(\d+)', content):
        max_group = max(max_group, int(match.group(1)))
    
    services_group_pattern = r'A500000123456789\d{10}'
    services_group_matches = re.findall(services_group_pattern, content)
    services_group_exists = len(services_group_matches) > 1
    
    build_file_section_end = content.find('/* End PBXBuildFile section */')
    file_ref_section_end = content.find('/* End PBXFileReference section */')
    sources_section_end = content.find('/* End PBXSourcesBuildPhase section */')
    groups_section_end = content.find('/* End PBXGroup section */')
    
    build_file_insert_pos = build_file_section_end
    file_ref_insert_pos = file_ref_section_end
    sources_insert_pos = sources_section_end
    groups_insert_pos = groups_section_end
    
    services_group_id = None
    services_group_block = ""
    
    if not services_group_exists:
        max_group += 1
        services_group_id = f"A500000123456789{max_group:010d}"
        
        group_children = []
        for swift_file in new_files:
            max_ref += 1
            file_ref_id = f"A200000123456789{max_ref:010d}"
            group_children.append(f"\t\t\t\t{file_ref_id} /* {swift_file} */,")
        
        services_group_block = f"""
\t\t{services_group_id} /* Services */ = {{
\t\t\tisa = PBXGroup;
\t\t\tchildren = (
{chr(10).join(group_children)}
\t\t\t);
\t\t\tpath = Services;
\t\t\tsourceTree = "<group>";
\t\t}};
"""
    
    new_build_entries = []
    new_file_ref_entries = []
    new_sources_entries = []
    
    for swift_file in new_files:
        max_ref += 1
        file_ref_id = f"A200000123456789{max_ref:010d}"
        
        max_build += 1
        build_file_id = f"A100000123456789{max_build:010d}"
        
        new_build_entries.append(
            f"\t\t{build_file_id} /* {swift_file} in Sources */ = {{isa = PBXBuildFile; fileRef = {file_ref_id} /* {swift_file} */; }};"
        )
        
        new_file_ref_entries.append(
            f"\t\t{file_ref_id} /* {swift_file} */ = {{isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = {swift_file}; sourceTree = \"<group>\"; }};"
        )
        
        new_sources_entries.append(
            f"\t\t\t{build_file_id} /* {swift_file} in Sources */,"
        )
    
    parts = []
    last_pos = 0
    
    parts.append(content[last_pos:build_file_insert_pos])
    last_pos = build_file_insert_pos
    parts.append('\n' + '\n'.join(new_build_entries))
    
    parts.append(content[last_pos:file_ref_insert_pos])
    last_pos = file_ref_insert_pos
    parts.append('\n' + '\n'.join(new_file_ref_entries))
    
    if not services_group_exists:
        parts.append(content[last_pos:groups_insert_pos])
        last_pos = groups_insert_pos
        parts.append(services_group_block)
    else:
        parts.append(content[last_pos:groups_insert_pos])
        last_pos = groups_insert_pos
    
    parts.append(content[last_pos:sources_insert_pos])
    last_pos = sources_insert_pos
    parts.append('\n' + '\n'.join(new_sources_entries))
    
    parts.append(content[last_pos:])
    
    new_content = ''.join(parts)
    
    if not services_group_exists:
        drv_group_match = re.search(r'(A50000012345678900000002 /\* DRIVE \*/ = \{[^}]*children = \()', new_content)
        if drv_group_match:
            insert_pos = drv_group_match.end()
            new_content = new_content[:insert_pos] + f"\n\t\t\t\t{services_group_id} /* Services */," + new_content[insert_pos:]
    
    PBXPROJ_PATH.write_text(new_content, encoding='utf-8')
    print(f"Updated {PBXPROJ_PATH}")
    return True

if __name__ == "__main__":
    update_pbxproj()