
import CoreData
import UIKit


final class CoreDataMaanger {
    
    // 싱글톤 패턴
    static let shared = CoreDataMaanger()
    
    private init() {}
    
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "BookSearcherApp") // ← .xcdatamodeld 파일명
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    // context 설정
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("falied to save context: \(error)")
            }
        }
    }
    
    // MARK: 최근 본 책 관련 함수
    
    // 최근 본 책 데이터를 생성
    func createRecentBook(book: SearchedBookData) {
        let recentBook = RecentBook(context: context)
        recentBook.isbn = book.isbn
        recentBook.title = book.title
        recentBook.thumbnail = book.thumbnailURL.absoluteString
        recentBook.updateDate = Date()
        
        saveContext()
    }
    
    // 최근 본 책 레코드의 날짜를 업데이트
    func updateRecentBookDate(isbn: String) {
        let fetchRequest: NSFetchRequest<RecentBook> = RecentBook.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(format: "isbn == %@", isbn)
        fetchRequest.fetchLimit = 1
        
        guard let book = try? context.fetch(fetchRequest).first else { return }
        book.updateDate = Date()
        saveContext()
    }
    
    // 최근 본 책 모든 레코드 획득
    func fetchAllRecentBooks() -> [RecentBook] {
        let fetchRequest: NSFetchRequest<RecentBook> = RecentBook.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updateDate", ascending: false)]
        
        return (try? context.fetch(fetchRequest)) ?? []
    }
    
    // isbn을 key로 해당하는 책 레코드를 획득
    func fetchOneRecentBook(isbn: String) -> RecentBook? {
        let fetchRequest: NSFetchRequest<RecentBook> = RecentBook.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(format: "isbn == %@", isbn)
        fetchRequest.fetchLimit = 1
        
        return try? context.fetch(fetchRequest).first
    }
    // 조건에 맞춰 최근 본 책 레코드를 추가하거나 업데이트
    func addRecentBook(book: SearchedBookData) {
        if let _ = fetchOneRecentBook(isbn: book.isbn) { // 이미 존재할경우 날짜만 업데이트
            updateRecentBookDate(isbn: book.isbn)
        } else { // 존재하지 않는다면 추가
            createRecentBook(book: book)
            trimRecentBooksIfNeed()
        }
    }
    
    //10건이 넘으면 삭제
    func trimRecentBooksIfNeed() {
        let books = fetchAllRecentBooks()
        if books.count > 10 { 
            for book in books[10...] {
                context.delete(book)
            }
        }
        saveContext()
    }
    
    // 최근본 책전부 삭제용 코드
    func deleteAllRecentBooks() {
        let books = fetchAllRecentBooks()
        books.forEach { context.delete($0) }
        saveContext()
    }
    
    // MARK: 즐겨찾기 관련 함수
    
    func createFavoritebook(book: SearchedBookData) {
        let favoriteBook = FavoriteBook(context: context)
        favoriteBook.isbn = book.isbn
        favoriteBook.title = book.title
        favoriteBook.author = book.author
        favoriteBook.translator = book.translator
        favoriteBook.thumbnail = book.thumbnailURL.absoluteString
        favoriteBook.price = book.salePrice
        favoriteBook.contents = book.contents
        
        saveContext()
        
    }
}
