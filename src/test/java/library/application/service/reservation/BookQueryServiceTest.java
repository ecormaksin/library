package library.application.service.reservation;

import library.LibraryDBTest;
import library.application.service.book.BookQueryService;
import library.domain.model.material.bibliography.Book;
import library.domain.model.material.bibliography.BookNumber;
import library.domain.model.material.bibliography.Keyword;
import library.domain.model.reservation.loanability.BookLoanabilities;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

import static org.junit.jupiter.api.Assertions.assertAll;
import static org.junit.jupiter.api.Assertions.assertEquals;

@LibraryDBTest
class BookQueryServiceTest {
    @Autowired
    BookQueryService bookQueryService;

    @Test
    void 本を検索できる() {
        Keyword keyword = new Keyword("ハンドブック");
        BookLoanabilities books = bookQueryService.search(keyword);

        assertAll(
                () -> assertEquals(1, books.size()),
                () -> assertEquals(
                        "RDRA2.0 ハンドブック: 軽く柔軟で精度の高い要件定義のモデリング手法 (神崎善司)",
                        books.asList().get(0).describeBook()));
    }

    @Test
    void 本を取得できる() {
        Book book = bookQueryService.findBook(new BookNumber(1));
        assertEquals(book.bookNumber().value(), 1);
    }
}