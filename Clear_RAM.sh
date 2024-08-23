#!/bin/bash

function show_info() {
    echo "When deciding between the three options for clearing RAM cache in Linux, it’s essential to understand what each option does, the implications of using it, and the contexts in which it might be appropriate. Below are the reasons and differences for using each option:"
    echo
    echo "### 1. Clear PageCache Only (sync; echo 1 > /proc/sys/vm/drop_caches)"
    echo "#### What It Does:"
    echo "- PageCache holds the contents of files that are read from or written to disk. This speeds up file access by avoiding disk reads for frequently accessed files."
    echo "- This command clears the PageCache without affecting directory entries (dentries) or inode caches."
    echo
    echo "#### Reasons to Use:"
    echo "- Safe for Production: It is the least disruptive option and is generally safe to use in production environments. Clearing just the PageCache typically has minimal impact on the system's performance."
    echo "- When Memory is Limited: If your system is running low on memory and you need to free up some space without affecting the filesystem metadata, this is the best choice."
    echo "- Avoids Performance Drops: Since only the file data is cleared, applications relying on the filesystem metadata (dentries and inodes) will not experience significant performance drops."
    echo
    echo "### 2. Clear Dentries and Inodes (sync; echo 2 > /proc/sys/vm/drop_caches)"
    echo "#### What It Does:"
    echo "- Dentries cache directory entries, which are used to resolve file paths to their corresponding inodes."
    echo "- Inodes store metadata about files, such as file ownership, permissions, and timestamps."
    echo "- This command clears the dentries and inodes, but not the PageCache."
    echo
    echo "#### Reasons to Use:"
    echo "- When Filesystem Metadata Changes: If the filesystem structure has undergone significant changes (like after heavy file operations or creating/deleting many files), clearing dentries and inodes can help reclaim memory."
    echo "- When Path Resolution is Slowed: Sometimes, the system can become sluggish due to a large amount of cached metadata, especially in environments with lots of small files. Clearing dentries and inodes can improve performance in such cases."
    echo
    echo "### 3. Clear PageCache, Dentries, and Inodes (sync; echo 3 > /proc/sys/vm/drop_caches)"
    echo "#### What It Does:"
    echo "- This command clears everything: PageCache, dentries, and inodes."
    echo
    echo "#### Reasons to Use:"
    echo "- Complete Cache Clear: Use this when you need to completely clear all caches to free up as much memory as possible."
    echo "- After Intensive Disk Operations: If the system has just completed very intensive disk operations, clearing all caches might help reset the memory usage and improve performance."
    echo "- Development/Testing Environments: It might be useful in non-production environments where you need to simulate a 'cold' system state or test performance under different caching scenarios."
    echo
    echo "#### Caution:"
    echo "- Potential Performance Impact: Since this command clears both data and metadata caches, applications might experience a significant slowdown as the system has to reload everything from disk. This is why it’s generally not recommended for production use unless you are certain of the need and impact."
    echo "- Repopulating Caches: After running this command, the system will need to repopulate all caches from scratch, which can lead to slower performance initially."
    echo
    echo "### Summary of Differences and Best Use Cases:"
    echo "- echo 1 > /proc/sys/vm/drop_caches: Safest and most focused on freeing file data cache. Best for typical use cases where memory needs to be reclaimed without impacting filesystem performance."
    echo "- echo 2 > /proc/sys/vm/drop_caches: Targets filesystem metadata, useful in scenarios where directory or file access becomes a bottleneck due to excessive cached metadata."
    echo "- echo 3 > /proc/sys/vm/drop_caches: Most aggressive option, clearing all caches. Suitable for non-production environments or specific situations where a complete cache reset is necessary, but can severely impact performance until caches are rebuilt."
}

echo "Choose an option to clear RAM cache:"
echo "1) Clear PageCache only (safest option)"
echo "2) Clear dentries and inodes"
echo "3) Clear PageCache, dentries, and inodes (most aggressive)"
echo "4) Info - Learn about the options before choosing"
read -p "Enter your choice (1/2/3/4): " choice

case $choice in
    1)
        echo "You chose to clear PageCache only."
        echo "This is the safest option and is recommended for production use."
        echo "Running: sync; sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'"
        sync; sudo sh -c 'echo 1 > /proc/sys/vm/drop_caches'
        echo "Cache cleared successfully!"
        ;;
    2)
        echo "You chose to clear dentries and inodes."
        echo "This option clears filesystem metadata and can help if directory access is slow."
        echo "Running: sync; sudo sh -c 'echo 2 > /proc/sys/vm/drop_caches'"
        sync; sudo sh -c 'echo 2 > /proc/sys/vm/drop_caches'
        echo "Cache cleared successfully!"
        ;;
    3)
        echo "You chose to clear PageCache, dentries, and inodes."
        echo "This is the most aggressive option and should be used with caution."
        echo "Running: sync; sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'"
        sync; sudo sh -c 'echo 3 > /proc/sys/vm/drop_caches'
        echo "Cache cleared successfully!"
        ;;
    4)
        show_info
	echo "No cache was cleared."
        ;;
    *)
        echo "Invalid choice. Please run the script again and choose a valid option."
        exit 1
        ;;
esac
