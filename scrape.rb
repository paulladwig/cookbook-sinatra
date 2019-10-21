require 'open-uri'
require 'nokogiri'
require 'pry'
require_relative 'recipe'

class Scrape
  def initialize
    @term = ""
    @findings = []
  end

  def scrape_term(term, num)
    @term = term.gsub(/\s/, "-")
    save_article(convert(@term))
    findings(num)
  end

  def findings(how_many)
    @findings.slice(0, how_many)
  end

  private

  def convert(term)
    doc = Nokogiri::HTML(open("http://www.letscookfrench.com/recipes/find-recipe.aspx?aqt=#{term}"))
    doc
  end

  def save_article(html)
    result = []
    html.search('div.m_contenu_resultat').each do |element|
      name = element.search('div.m_titre_resultat').text.strip
      description = element.search('div.m_texte_resultat').text.strip
      prep_time = time_total(element.search('div.m_detail_time').text.strip)
      difficulty = difficulty_only(element.search('div.m_detail_recette').text.strip)
      result << Recipe.new(name, description, prep_time, difficulty)
    end
    @findings = result
  end

  def time_total(prep_time)
    total = [0, 0]
    prep_time.scan(/\d\d?\sm?i?n?h?/).map do |element|
      sub_a = element.split(" ")
      sub_a[1] == "min" ? total[1] += sub_a[0].to_i : total[0] += sub_a[0].to_i
    end
    if total[1] > 59
      total[0] += total[1] / 60
      total[1] -= (total[1] / 60) * 60
    end
    total[0].zero? ? "#{total[1]}min" : "#{total[0]}h #{total[1]}min"
  end

  def difficulty_only(diff_str)
    diff_str.gsub(/^[\w]*\s\-\s[\w]*\s?[\w]*\s\-\s/, "").scan(/^[\w]*\s[\w?]*/)[0]
  end
end
