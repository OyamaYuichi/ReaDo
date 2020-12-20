FactoryBot.define do
  factory :book do
    title { "嫌われる勇気" }
    image_url { "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/5819/9784478025819.jpg?_ex=200x200" }
    url { "https://books.rakuten.co.jp/rb/12570589/" }
    author { "岸見一郎/古賀史健" }
    publisher { "ダイヤモンド社"}
    isbn { "9784478025819"}
  end

  factory :second_book, class: Book do
    title { "幸せになる勇気" }
    image_url { "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/6119/9784478066119.jpg?_ex=200x200" }
    url { "https://books.rakuten.co.jp/rb/13604272/" }
    author { "岸見一郎/古賀史健" }
    publisher { "ダイヤモンド社"}
    isbn { "9784478066119"}
  end

  factory :third_book, class: Book do
    title { "完訳7つの習慣" }
    image_url { "https://thumbnail.image.rakuten.co.jp/@0_mall/book/cabinet/1014/9784863941014.jpg?_ex=200x200" }
    url { "https://books.rakuten.co.jp/rb/16478139/" }
    author { "スティーブ・R．コヴィー/フランクリン・コヴィー・ジャパン" }
    publisher { "FCEパブリッシング（キングベアー出版）"}
    isbn { "9784863941014"}
  end
end