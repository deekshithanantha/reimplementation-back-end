# frozen_string_literal: true

class AssignmentParticipant < Participant
  belongs_to :user
  validates :handle, presence: true

  def set_handle
    self.handle = if user.handle.nil? || (user.handle == '')
                    user.name
                  elsif Participant.exists?(assignment_id: assignment.id, handle: user.handle)
                    user.name
                  else
                    user.handle
                  end
    self.save
  end

  def aggregate_teammate_review_grade(maps)
    return 0 if maps.empty?
    obtained_score = 0    
    total_reviewers = maps.size
    maps.each do |map|
       obtained_score += map.review_grade
    end
     ((obtained_score/total_reviewers)*100).round(2)
  end
end