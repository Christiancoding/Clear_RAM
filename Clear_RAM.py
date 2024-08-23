import os
import sys

def show_info():
    print("When deciding between the three options for clearing RAM cache in Linux, it’s essential to understand what each option does, the implications of using it, and the contexts in which it might be appropriate. Below are the reasons and differences for using each option:\n")
    print("### 1. Clear PageCache Only (sync; echo 1 > /proc/sys/vm/drop_caches)\n")
    print("#### What It Does:")
    print("- PageCache holds the contents of files that are read from or written to disk. This speeds up file access by avoiding disk reads for frequently accessed files.")
    print("- This command clears the PageCache without affecting directory entries (dentries) or inode caches.\n")
    print("#### Reasons to Use:")
    print("- Safe for Production: It is the least disruptive option and is generally safe to use in production environments. Clearing just the PageCache typically has minimal impact on the system's performance.")
    print("- When Memory is Limited: If your system is running low on memory and you need to free up some space without affecting the filesystem metadata, this is the best choice.")
    print("- Avoids Performance Drops: Since only the file data is cleared, applications relying on the filesystem metadata (dentries and inodes) will not experience significant performance drops.\n")
    print("### 2. Clear Dentries and Inodes (sync; echo 2 > /proc/sys/vm/drop_caches)\n")
    print("#### What It Does:")
    print("- Dentries cache directory entries, which are used to resolve file paths to their corresponding inodes.")
    print("- Inodes store metadata about files, such as file ownership, permissions, and timestamps.")
    print("- This command clears the dentries and inodes, but not the PageCache.\n")
    print("#### Reasons to Use:")
    print("- When Filesystem Metadata Changes: If the filesystem structure has undergone significant changes (like after heavy file operations or creating/deleting many files), clearing dentries and inodes can help reclaim memory.")
    print("- When Path Resolution is Slowed: Sometimes, the system can become sluggish due to a large amount of cached metadata, especially in environments with lots of small files. Clearing dentries and inodes can improve performance in such cases.\n")
    print("### 3. Clear PageCache, Dentries, and Inodes (sync; echo 3 > /proc/sys/vm/drop_caches)\n")
    print("#### What It Does:")
    print("- This command clears everything: PageCache, dentries, and inodes.\n")
    print("#### Reasons to Use:")
    print("- Complete Cache Clear: Use this when you need to completely clear all caches to free up as much memory as possible.")
    print("- After Intensive Disk Operations: If the system has just completed very intensive disk operations, clearing all caches might help reset the memory usage and improve performance.")
    print("- Development/Testing Environments: It might be useful in non-production environments where you need to simulate a 'cold' system state or test performance under different caching scenarios.\n")
    print("#### Caution:")
    print("- Potential Performance Impact: Since this command clears both data and metadata caches, applications might experience a significant slowdown as the system has to reload everything from disk. This is why it’s generally not recommended for production use unless you are certain of the need and impact.")
    print("- Repopulating Caches: After running this command, the system will need to repopulate all caches from scratch, which can lead to slower performance initially.\n")
    print("### Summary of Differences and Best Use Cases:")
    print("- echo 1 > /proc/sys/vm/drop_caches: Safest and most focused on freeing file data cache. Best for typical use cases where memory needs to be reclaimed without impacting filesystem performance.")
    print("- echo 2 > /proc/sys/vm/drop_caches: Targets filesystem metadata, useful in scenarios where directory or file access becomes a bottleneck due to excessive cached metadata.")
    print("- echo 3 > /proc/sys/vm/drop_caches: Most aggressive option, clearing all caches. Suitable for non-production environments or specific situations where a complete cache reset is necessary, but can severely impact performance until caches are rebuilt.")

def clear_cache(option):
    if option == 1:
        command = "sudo sh -c 'sync; echo 1 > /proc/sys/vm/drop_caches'"
    elif option == 2:
        command = "sudo sh -c 'sync; echo 2 > /proc/sys/vm/drop_caches'"
    elif option == 3:
        command = "sudo sh -c 'sync; echo 3 > /proc/sys/vm/drop_caches'"
    else:
        print("Invalid option. Exiting.")
        sys.exit(1)
    
    print(f"Running: {command}")
    os.system(command)
    print("Cache cleared successfully!")

def main():
    print("Choose an option to clear RAM cache:")
    print("1) Clear PageCache only (safest option)")
    print("2) Clear dentries and inodes")
    print("3) Clear PageCache, dentries, and inodes (most aggressive)")
    print("4) Info - Learn about the options before choosing")
    choice = input("Enter your choice (1/2/3/4): ")

    if choice == '4':
        show_info()
        print("No cache was cleared.")
    else:
        try:
            option = int(choice)
            clear_cache(option)
        except ValueError:
            print("Invalid input. Please enter a number between 1 and 4.")

if __name__ == "__main__":
    main()

